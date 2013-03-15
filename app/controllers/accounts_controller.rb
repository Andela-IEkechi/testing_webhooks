class AccountsController < ApplicationController
  load_and_authorize_resource :user
  before_filter :load_account

  def edit
  end

  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "Your account was updated"
    else
      flash[:alert] = "Your account could not be updated"
    end
    redirect_to edit_user_account_path(@account.user,@account)
  end


  private
  def load_account
    @account = @user.account
    @plans = Plan::PLANS.collect{|k,v| [v[:title] ,k.to_s]}
  end
end
