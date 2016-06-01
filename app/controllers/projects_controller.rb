class ProjectsController < ApplicationController
  respond_to :json

  def index
    render json: @projects
  end

  def show
    render json: @project
  end

  def create
    #TODO need to check if current_user MAY create a project
    if @project.valid? && @project.save
      #create a member in the project for the current user
      member = @project.members.owners.create(user: current_user)
      render json: @project
    else
      render json: {errors: @project.errors.full_messages}, status: 422
    end
  end

  def update
    @project.update_attributes(project_params)
    if @project.valid? && @project.save
      render json: @project
    else
      render json: {errors: @project.errors.full_messages}, status: 422
    end    
  end

  def destroy
    if @project.delete
      render json: @project
    else
      render json: {errors: @project.errors.full_messages}, status: 422
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :id, :_destroy,
      :name
      # review note: add in status attributes to allow creating new statuses as part of a project, and to reorder them.
      
    )
  end

  def load_resource
    # we need to scope to "friendly" to use slugs
    @resource_scope = Project.friendly if ['show', 'update', 'destroy', 'create'].include?(action_name) 
    super
  end  
end
