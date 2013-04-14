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

  def public
    @projects = Project.public
  end

  def invite
    recipients = @project.memberships.collect(&:email).uniq
    InviteMailer.invite_request(recipients, current_user, @project).deliver
    InviteMailer.invite_confirm(current_user, @project).deliver
    flash[:notice] = "Your request to join <b>#{@project.title}</b> was sent to the project administrator".html_safe
    redirect_to projects_public_path
  end

  private

  #I'm having massive headaches defining propper cancan rules for getting this done,
  #so I'd rather do it here for now
  def filter_by_participation
    #only allow projects we participate in or own
    if @projects
      @projects.select!{|p| p.participants.include?(current_user) || (p.user_id == current_user.id)}
    end
    if @project
      @project = nil unless (!@project.private || @project.user_id == current_user.id) || @project.participants.include?(current_user)
    end
  end

end

