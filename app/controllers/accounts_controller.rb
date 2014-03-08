class AccountsController < ApplicationController
  load_and_authorize_resource :user
  before_filter :load_account

  def edit
    current_user.ensure_authentication_token!
  end

  def payment_return #TODO: Edit this for payment success and failure
    redirect_to edit_user_account_path(@account.user)
  end

  def payment_update
    plan = Plan::PLANS.keys.each.select{|p| Plan::PLANS[p][:price_usd] == params["li_1_price"].to_i}.first.to_s
    if @account.can_downgrade?(plan)
      if !(plan.blank?) && @account.change_to(plan.to_s) && @account.save
        flash[:notice] = "Downgrade request successful. You will receive an email as soon as your downgrade is completed."
      else
        flash[:alert] = "Downgrade request sent. However, we encountered a problem while updating your account. Please contact accounts@conductor-app.co.za for assistance"
      end
    else
      flash[:alert] = "Sorry, your account can not be downgraded at this time."
    end
    redirect_to edit_user_account_path(@account.user)
  end

  private
  def load_account
    @account = @user.account
  end
end
