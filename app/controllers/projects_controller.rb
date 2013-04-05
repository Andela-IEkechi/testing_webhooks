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
      flash[:notice] = "Project was added"
      redirect_to project_path(@project)
    else
      flash[:alert] = "Project could not be created"
      render 'new'
    end
  end

  def edit
  end

  def update
    #before we update the project, we need to convert membership[user][email] entries into user_ids


    if @project.update_attributes(params[:project])
      flash[:notice] = "Project was updated"
      redirect_to edit_project_path(@project)
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

end

