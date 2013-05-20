class OverviewsController < ApplicationController
  load_and_authorize_resource :overview, :through => :current_user

  def show
  end

  def new
  end

  def create
    #ensure it's only for the current user
    @overview.user = current_user

    if @overview.save
      flash.keep[:notice] = "Overview was added."
      redirect_to user_overview_path(current_user, @overview)
    else
      flash[:alert] = "Overview could not be created"
      render 'new'
    end
  end
end
