require 'spec_helper'

describe AccountsController, :type => :controller do
  before(:each) do
    login_user
  end
  #users can only act on their own accounts, so we need to make sure the account belongs to the logged in user
  let(:account) {create(:account, :user => @user)}

  it ".load_account" do
    get :edit, :id => @user.account, :user_id => @user
    expect(assigns(:account)).to eq(@user.account)
  end

  describe "GET #edit" do
    before(:each) do
      @user.authentication_token = nil
      get :edit, :id => @user.account, :user_id => @user
      @user.reload
    end

    it "ensures that the user has an auth token" do
      @user.authentication_token.should_not eq(nil)
    end

    it "renders the :edit template" do
      response.should render_template(:edit)
    end
  end

  describe "downgrade_to_free" do
    before(:each) do
      @account = @user.account
      @account.upgrade
      @account.save
      @params = {
        "account" => @account.id,
        "li_1_name" => "free",
        "forfeit" => "19.20"
      }
    end

    it "should assign the new plan" do
      @first_plan = @account.current_plan
      post :downgrade_to_free, @params.merge(:user_id => @user)
      assigns(:account).current_plan.to_s.should_not eq(@first_plan.to_s)
    end

    it "should give the correct success notice" do
      get :downgrade_to_free, @params.merge(:user_id => @user)
      flash[:notice].should =~ /Downgrade request successful. You will receive an email as soon as your downgrade is completed./i
    end

    it "should give the correct alert when disallowed" do
      create(:private_project, :user_id => @user.id)
      get :downgrade_to_free, @params.merge(:user_id => @user)
      flash[:alert].should =~ /Sorry, your account can not be downgraded at this time./i
    end

    it "should redirect" do
      get :downgrade_to_free, @params.merge(:user_id => @user)
      response.should be_redirect
    end
  end

  describe "payment return" do
    before(:each) do
      @x = [10.00,25.00,70.00].sample
      @params = {
        "mode" => '2CO',
        "sid" => Rails.configuration.checkout[:checkout_account],
        "demo" => 'Y',
        "li_1_price" => @x,
        "li_1_name" => 'Platinum',
        "li_1_tangible" => 'N',
        "li_1_quanity" => '1',
        'fixed' => 'Y',
        "li_1_startup_fee" => '0',
        "li_1_type" => 'product',
        "li_1_recurrence" => '1 Month',
        "li_1_duration" => 'Forever',
        "currency_code" => 'USD',
        "order_number" => "564654",
        "total" => @x.to_s,
        "credit_card_processed" => "Y",
        "key" => Digest::MD5.hexdigest((Rails.configuration.checkout[:encryption_key] + Rails.configuration.checkout[:checkout_account] + "1" + @x.to_s)).upcase
      }
    end

    context "successful payment" do
      context "upgrade" do
        it "should assign the new plan" do
          @account = @user.account
          @first_plan = @account.current_plan
          post :payment_return, @params.merge(:user_id => @user)
          assigns(:account).current_plan.to_s.should_not eq(@first_plan.to_s)
        end

        it "should give the correct success notice" do
          get :payment_return, @params.merge(:user_id => @user)
          flash[:notice].should =~ /Payment was successful. Your subscription has been updated to #{assigns(:account).current_plan[:title]}/i
        end

        it "should give the correct alert when successful with save errors" do
          @params["li_1_price"] = "90.00"
          get :payment_return, @params.merge(:user_id => @user)
          flash[:alert].should =~ /Payment was successful. However, we encountered a problem while updating your account. Our support staff have been notified and will be in contact shortly to assist you./i
        end
      end

      context "downgrade" do
        before(:each) do
          @account = @user.account
          @account.change_to("large")
          @account.save
          @params["li_1_price"] = 25.00
        end

        it "assigns the new plan" do
          expect {
            post :payment_return, @params.merge(:user_id => @user)
          }.not_to change{@user.account.current_plan.to_s}
        end

        it "gives the correct success notice" do
          get :payment_return, @params.merge(:user_id => @user)
          expect(flash[:notice]).to eq("Downgrade request successful. You will receive an email as soon as your downgrade is completed.")
        end

        it "gives the correct alert when successful with save errors" do
          @params["li_1_price"] = "5.00"
          get :payment_return, @params.merge(:user_id => @user)
          expect(flash[:alert]).to eq("Downgrade request sent. However, we encountered a problem while updating your account. Our support staff have been notified and will be in contact shortly to assist you.")
        end
      end
    end

    context "payment failed" do
      it "should generate the correct flash message if payment failed" do
        @params["key"] = "invalid"
        get :payment_return, @params.merge(:user_id => @user)
        flash[:alert].should =~ /Payment could not be processed. Your subscription was not updated./i
      end
    end

    it "resets the authentication_token" do
      expect {
        get :payment_return, @params.merge(:user_id => @user)
        @user.reload
      }.to change{@user.authentication_token}
    end

    it "should redirect" do
      get :payment_return, @params.merge(:user_id => @user)
      response.should be_redirect
    end
  end

  context "ajax_startup_fee" do
    before(:each) do
      @account = @user.account
      @account.started_on = (Time.now - 1.month - 12.days).strftime('%Y-%m-%d')
      @account.plan = "medium"
      @account.save

      #make sure the request is json
      request.env['CONTENT_TYPE'] = 'application/json'
      request.accept = "application/json"

      @params = {
        "mode" => '2CO',
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
        "account" => @account.id
      }
    end
    it "should calculate the pro_rata amount" do
      post :ajax_startup_fee, @params.merge(:user_id => @user)
      tmp = JSON.parse(response.body)
      expect(tmp["li_1_startup_fee"].to_f).to eq(-1*subject.send(:pro_rata, @account))
    end

    it "sets startup_fee to 0.00 if new subscription" do
      @account.plan = "free"
      @account.started_on = nil
      @account.save
      post :ajax_startup_fee, @params.merge(:user_id => @user)
      tmp = JSON.parse(response.body)
      expect(tmp["li_1_startup_fee"]).to eq(0.0)
    end

    it "sets startup_fee to negative pro_rata amount if upgrade" do
      post :ajax_startup_fee, @params.merge(:user_id => @user)
      tmp = JSON.parse(response.body)
      expect(tmp["li_1_startup_fee"]).to eq(-1*subject.send(:pro_rata, @account))
    end

    it "sets forfeit to pos pro_rata, startup_fee to 0.00 if downgrade" do
      @account.plan = "large"
      @account.save
      @params["li_1_price"] = "10.00"
      post :ajax_startup_fee, @params.merge(:user_id => @user)
      tmp = JSON.parse(response.body)
      expect(tmp["forfeit"]).to eq(subject.send(:pro_rata, @account))
    end
  end
end

