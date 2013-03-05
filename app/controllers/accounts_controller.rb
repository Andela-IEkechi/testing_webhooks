class AccountsController < ApplicationController
  def edit
    @account = Account.find(params[:id])    
  end
end
