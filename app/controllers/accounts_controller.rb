class AccountsController < ApplicationController
  load_and_authorize_resource :user
  before_filter :load_account

  def edit
    current_user.ensure_authentication_token!
  end

  def payment_return #TODO: Edit this for payment success and failure
    redirect_to edit_user_account_path(@account.user)
  end

  def payment_update #TODO: Edit this for account payment update: downgrade or cancellation
    redirect_to edit_user_account_path(@account.user)
  end

  private
  def load_account
    @account = @user.account
  end
end
