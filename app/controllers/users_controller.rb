class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]

  def index
    if user_signed_in?
      redirect_to projects_path
    else
      #render some welcome message for the uninititated
    end
  end
end
