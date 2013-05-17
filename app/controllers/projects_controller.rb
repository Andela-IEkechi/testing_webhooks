class ProjectsController < ApplicationController
  load_and_authorize_resource :project, :except => [:index]

  def index
    #limit the projects to the ones we have memberships to
    @projects = current_user.memberships.collect(&:project)
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
        #assign the new owner
        @project.update_attribute(:user_id, new_user_id.to_i)
        #make sure they are an admin
        @project.memberships.for_user(@project.user_id).first.admin!

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
    title = @project.to_s
    if (@project.user_id == current_user.id) && @project.destroy
      flash[:notice] = "#{title} has been permanently deleted"
      redirect_to projects_path()
    else
      flash[:notice] = "#{title} could not be deleted"
      redirect_to project_path(@project)
    end
  end

  def public
    @projects = Project.public
  end

  def invite
    InviteMailer.invite_request(current_user, @project).deliver
    InviteMailer.invite_confirm(current_user, @project).deliver
    flash[:notice] = "Your request to join <b>#{@project.title}</b> was sent to the project administrator".html_safe
    redirect_to projects_public_path
  end

end

