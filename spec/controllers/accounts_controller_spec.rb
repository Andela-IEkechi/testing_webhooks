require 'spec_helper'

describe AccountsController do
  before(:each) do
    login_user
  end
  #users can only act on their own accounts, so we need to make sure the account belongs to the logged in user
  let(:account) {create(:account, :user => @user)}

  it "should load_account" do
    get :edit, :id => user.account, :user_id => user.id
    assigns(:account).should eq(user.account)
  end

  describe "GET #edit" do
    before(:each) do
      user.authentication_token = nil
      get :edit, :id => user.account, :user_id => user.id
      user.reload
    end
    it "ensures that the user has an auth token" do
      user.authentication_token.should_not eq(nil)
    end

    it "renders the :edit template" do
      response.should render_template(:edit)
    end
  end

  describe "payment return" do
  #   def payment_return
  #   #compare checksum to ensure valid payment
  #   params["encryption_key"] = Rails.configuration.paygate[:encryption_key]
  #   params["seller_id"] = Rails.configuration.paygate[:seller_id] #or 2Checkout account number
  #   checksum_fields = ["encryption_key","seller_id","order_number","total"]
  #   #UPPERCASE(MD5_ENCRYPTED(Secret Word + Seller ID + order_number + Sale Total))
  #   checksum = Digest::MD5.hexdigest(checksum_fields.collect{|c| params[c]}.join("").upcase)

  #   valid_payment = (checksum == params["key"])
  #   successful = (params["credit_card_processed"] == "Y")

  #   if valid_payment && successful
  #     #get the correct plan amount
  #     startup_fee = ("free" == @account.current_plan && Date.today.day == @account.started_on.day) ? 0.00 : (- pro_rata(@account))
  #     plan_amount = params["total"].to_i - startup_fee
  #     #get the new plan and update the user account
  #     plan = Plan::PLANS.keys.each.select{|p| Plan::PLANS[p][:price_usd] == plan_amount}.first.to_s
  #     #change account plan and notify
  #     @account.started_on = Date.today
  #     if !(plan.blank?) && @account.change_to(plan.to_s) && @account.save
  #       flash[:notice] = "Payment was successful. Your subscription has been updated to #{@account.current_plan[:title]}"
  #     else
  #       flash[:alert] = "Payment was successful. However, we encountered a problem while updating your account. Our support staff have been notified and will be in contact shortly to assist you."
  #     end
  #   else
  #     flash[:alert] = "Payment could not be processed. Your subscription was not updated."
  #   end
  #   current_user.reset_authentication_token!
  #   redirect_to edit_user_account_path(@account.user)
  # end
    context "successful payment" do
      before(:each) do
        @x = [10.00,25.00,70.00].sample
        #get request with correct params
        params = {
          "mode" => '2CO',
          "sid" => Rails.configuration.checkout[:checkout_account],
          "demo" => 'Y',
          "li_1_price" => @x,
          "li_1_name" => 'Platinum',
          "li_1_tangible" => 'N',
          "li_1_quanity" => '1',
          'fixed' => 'Y',
          "li_1_startup_fee" => '',
          "li_1_type" => 'product',
          "li_1_recurrence" => '1 Month',
          "li_1_duration" => 'Forever',
          "currency_code" => 'USD'
        }
      end

      it "should assign the new plan", :focus=>true do
        @first_plan = account.current_plan
        get :payment_return, :user_id => @user.id  #, :id => account.id
        assigns(:account).current_plan.to_s.should_not eq(@first_plan.to_s)
      end


      it "should give the correct success notice" do
        get :payment_return, :user_id => user.id
        flash[:notice].should =~ /Payment was successful. Your subscription has been updated to #{assigns(:account).current_plan[:title]}/i
      end

      it "should give the correct alert when successful with save errors" do
        get :payment_return, :user_id => user.id
        flash[:alert].should =~ /Payment was successful. However, we encountered a problem while updating your account. Our support staff have been notified and will be in contact shortly to assist you./i
      end
    end

    context "case 2 & 3" do
      before(:each) do
        @x = [10.00,25.00,70.00].sample
        #@c = Digest::MD5.hexdigest()
      end
      it "should generate the correct flash message if payment failed" do
        get :payment_return, :user_id => user
        flash[:alert].should =~ /Payment could not be processed. Your subscription was not updated./i
      end
    end

    it "should reset the authentication_token" do
      auth = user.authentication_token
      get :payment_return, :user_id => user
      user.reload
      user.authentication_token.should_not eq(auth)
    end

    it "should redirect" do
      get :payment_return, :user_id => user
      response.should be_redirect
    end
  end

  context "ajax_startup_fee" do
    it "should calculate the pro_rata amount" do
      account.plan = "medium"
      account.started_on = (Time.now - 1.month - 12.days).strftime('%Y-%m-%d')
      account.save
      user.ensure_authentication_token
      user.save

      params = {"mode" => '2CO',
                "sid" => Rails.configuration.checkout[:checkout_account],
                "demo" => 'Y',
                "li_1_price" => '70.00',
                "li_1_name" => 'Platinum',
                "li_1_tangible" => 'N',
                "li_1_quanity" => '1',
                'fixed' => 'Y',
                "li_1_startup_fee" => '',
                "li_1_type" => 'product',
                "li_1_recurrence" => '1 Month',
                "li_1_duration" => 'Forever',
                "currency_code" => 'USD',
                "account" => account.id }
      post :ajax_startup_fee, :account => account, :user => user, :params => params

      started_on = account.started_on.day
      old_amount = 25
      days_of_month = Time.now.end_of_month.day
      today = Time.now.day
      rest_of_days = (started_on < today) ? (days_of_month - today - started_on) : (started_on - today)
      my_pro_rata = (old_amount.to_f/days_of_month.to_f*rest_of_days).round(2)
      self.controller.params["li_1_startup_fee"].to_f.should eq(- my_pro_rata)
    end
  end
end

