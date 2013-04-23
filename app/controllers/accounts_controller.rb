class AccountsController < ApplicationController
  load_and_authorize_resource :user
  before_filter :load_account

  def edit
    current_user.ensure_authentication_token!
  end

  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "Your account was updated"
    else
      flash[:alert] = "Your account could not be updated"
    end
    redirect_to edit_user_account_path(@account.user,@account)
  end

  def payment_failure
    #do something if the payment failed
    flash[:alert] = "Payment could not be processed. Your subscription was not updated"
    redirect_to edit_user_account_path(@account.user)
  end

  def payment_success
    #get the new plan and update the user account
    @account.change_to(params[:plan])
    if @account.save
      flash[:notice] = "Payment was successful. Your subscription has been updated to #{@account.current_plan[:title]}"
    else
      flash[:alert] = "Payment was successful. However, we encountered a problem while updating your account. Please contact accounts@conductor-app.co.za for assistance"
    end
    redirect_to edit_user_account_path(@account.user)
  end


  private
  def load_account
    @account = @user.account
  end
end
