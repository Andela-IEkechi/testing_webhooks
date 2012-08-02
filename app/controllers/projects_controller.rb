class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new()
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:info] = "Project was added"
      redirect_to project_path(@project)
    else
      flash[:alert] = "Project could not be created"
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:info] = "Project was updated"
      redirect_to project_path(@project)
    else
      flash[:alert] = "Project could not be updated"
      render :action => 'edit'
    end

  end

  def destroy
    @project = Project.find(params[:id])
    @project.delete
    redirect_to projects_path()
  end
end

