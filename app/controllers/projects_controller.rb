class ProjectsController < ApplicationController

  def show
    authorize @project
  end

  def create
    authorize @project

    #also create an owner membership
    @project.memberships.owner.build(user: current_user)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, success: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { redirect_to :back, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private



  def project_params
    case action_name
    when "create"
      params[:project] ||= {title: "new project #{current_user.projects.count + 1}"}
    end

    params.require(:project).permit(:id, :_destroy, :title)
  end
end
