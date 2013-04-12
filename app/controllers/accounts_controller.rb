class AccountsController < ApplicationController
  load_and_authorize_resource :user
  before_filter :load_account

  def edit
    current_user.reset_authentication_token!
  end

  def update
    current_user.reset_authentication_token!
    if @account.update_attributes(params[:account])
      flash[:notice] = "Your account was updated"
    else
      flash[:alert] = "Your account could not be updated"
    end
    redirect_to edit_user_account_path(@account.user,@account)
  end

  def payment_failure
    current_user.reset_authentication_token!
    #do something if the payment failed
    flash[:alert] = "Payment could not be processed. Your subscription was not updated"
    redirect_to edit_user_account_path(@account.user,@account)
  end

  def payment_success
    current_user.reset_authentication_token!
    #get the new plan and update the user account
    @account.change_to(params[:plan])
    flash[:notice] = "Payment was successful. Your subscription has been updated to #{current_user.account.current_plan[:title]}"
    redirect_to edit_user_account_path(@account.user,@account)
  end


  private
  def load_account
    @account = @user.account
  end
end
