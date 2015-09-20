class OverviewsController < ApplicationController
  before_filter :pick_projects, :only => [:create, :update]

  load_and_authorize_resource :overview, :through => :current_user

  def show
    #return all the projects for this overview
    @projects = @overview.projects unless @overview.any_project?
    @projects ||= Membership.for_user(current_user.id).collect(&:project)
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

  def edit
  end

  def update
    if @overview.update_attributes(params[:overview])
      flash[:notice] = "Overview was updated"
      redirect_to user_overview_path(@overview.user, @overview)
    else
      flash[:alert] = "Overview could not be updated"
      render 'edit'
    end
  end

  def destroy
    if @overview.destroy
      redirect_to root_path()
    else
      flash[:alert] = "Overview could not be deleted"
      render 'show'
    end
  end

  private

  def pick_projects
    if params[:overview][:project_all]
      params[:overview][:project_ids] = [] if "1" == params[:overview][:project_all]
      params[:overview].delete(:project_all)
    end
    p params
  end
end
