class ProjectsController < ApplicationController
  load_and_authorize_resource :project

  def index
  end

  def show
  end

  def new
  end

  def create
    @project.user = current_user
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
    remove_user = ((params[:project].delete(:remove_me) == '1') rescue false)
    new_user_id = (params[:project].delete(:user_id) rescue nil)

    if @project.update_attributes(params[:project])
      flash[:notice] = "Project was updated"
      #remove the current user from the project memberships
      unless new_user_id.blank?
        @project.update_attribute(:user_id, new_user_id.to_i)
        flash[:notice] = "Project was transfered to #{@project.user}"
        if remove_user
          @project.memberships.for_user(current_user.id).first.delete
          flash[:notice] = "Project was transfered to #{@project.user} and you have been removed from it"
          redirect_to projects_path() and return
        end
      end
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

