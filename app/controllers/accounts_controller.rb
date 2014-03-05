class AccountsController < ApplicationController
  load_and_authorize_resource :user, :except => [:ajax_startup_fee]
  before_filter :load_account, :except => [:ajax_startup_fee]
  skip_before_filter :verify_authenticity_token, :only => [:payment_return]

  def edit
    current_user.ensure_authentication_token!
  end

  def payment_update #TODO: Edit this for account payment update: downgrade or cancellation
    redirect_to edit_user_account_path(@account.user)
  end

  def payment_return
    binding.pry
    #compare checksum to ensure valid payment
    params["encryption_key"] = Rails.configuration.paygate[:encryption_key]
    params["seller_id"] = Rails.configuration.paygate[:seller_id] #or 2Checkout account number
    checksum_fields = ["encryption_key","seller_id","order_number","total"]
    #UPPERCASE(MD5_ENCRYPTED(Secret Word + Seller ID + order_number + Sale Total))
    checksum = Digest::MD5.hexdigest(checksum_fields.collect{|c| params[c]}.join("").upcase)

    valid_payment = (checksum == params["key"])
    successful = (params["credit_card_processed"] == "Y")

    if valid_payment && successful
      #get the correct plan amount
      plan_amount = params["total"].to_i - params["li_1_startup_fee"]
      #get the new plan, update the user account and notify
      plan = Plan::PLANS.keys.each.select{|p| Plan::PLANS[p][:price_usd] == plan_amount}.first.to_s
      @account.started_on = Date.today
      if !(plan.blank?) && @account.change_to(plan.to_s) && @account.save
        flash[:notice] = "Payment was successful. Your subscription has been updated to #{@account.current_plan[:title]}"
      else
        flash[:alert] = "Payment was successful. However, we encountered a problem while updating your account. Our support staff have been notified and will be in contact shortly to assist you."
      end
    else
      flash[:alert] = "Payment could not be processed. Your subscription was not updated."
    end
    current_user.reset_authentication_token!
    redirect_to edit_user_account_path(@account.user)
  end

  def ajax_startup_fee
    @account = Account.find(params['account'].to_i)
    params["li_1_startup_fee"] = ("free" == @account.current_plan && Date.today.day == @account.started_on.day) ? "0.00" : (- pro_rata(@account)).to_s
    params.delete("account")
    respond_to do |format|
      format.json do
        render :json => params
      end
    end
  end

  private
  def load_account
    @account = @user.account
  end

  def pro_rata(account) 
  #this calculates the portion of the old_amount that has already been paid for the rest of the month
  #that is why the first month's payment must be the new amount - pro_rata amount
    @account = account
    plan = @account.current_plan.to_s.to_sym
    old_amount = Plan::PLANS[plan][:price_usd]
    days_of_month = Time.now.end_of_month.day
    started_on = @account.started_on ? @account.started_on.day : 0
    today = Time.now.day
    rest_of_days = (started_on < today) ? (days_of_month - today - started_on) : (started_on - today)
    pro_rata_amount = (old_amount.to_f/days_of_month.to_f*rest_of_days).round(2)
    return pro_rata_amount
  end
end
