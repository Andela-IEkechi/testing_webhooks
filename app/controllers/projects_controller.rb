class ProjectsController < ApplicationController
  load_and_authorize_resource :project

  def index
  end

  def show
  end

  def new
  end

  def create
    if @project.save
      flash[:info] = "Project was added"
      redirect_to project_path(@project)
    else
      flash[:alert] = "Project could not be created"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:info] = "Project was updated"
      redirect_to project_path(@project)
    else
      flash[:alert] = "Project could not be updated"
      render 'edit'
    end

  end

  def destroy
    if @project.destroy
      redirect_to projects_path()
    else
      redirect_to project_path(@project)
    end
  end

  def access
    #get all the users accross all the projects to select from
    @participants = current_user.projects.collect(&:participants).flatten.uniq
  end
end

