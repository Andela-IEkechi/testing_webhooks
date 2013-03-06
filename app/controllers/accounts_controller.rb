class AccountsController < ApplicationController
  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])

    if @account.update_attributes(params[:account])
      flash[:notice] = "Your account was updated"
    else
      flash[:alert] = "Your account could not be updated"
    end
    redirect_to edit_user_account_path(@account.user,@account)
  end
end
