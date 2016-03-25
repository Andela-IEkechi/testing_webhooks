class ProjectsController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def show
    authorize @project
    params[:tab] = "settings" if @project.created_at == @project.updated_at
  end

  def create
    authorize @project

    respond_to do |format|
      if @project.save

        #also create an owner membership
        @project.members.owner.create(user: current_user)

        format.html { redirect_to project_path(@project, params: {tab: 'settings'}), success: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project}
      else
        format.html { render nothing: true, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @project

    # @project.update(project_params)
    # respond_with(@project)

    respond_to do |format|
      if @project.update(project_params)

        #we need to broadcast to every listening user concerned, that the project has been updated
        @project.members.each do |m|
          ActionCable.server.broadcast "projects_#{m.user_id}", { id: @project.id, title: @project.title, success: "#{@project.title} has been updated" }
        end

        format.html { redirect_to project_path(@project, params: {tab: "settings"}), success: 'Project was successfully updated.'}
        format.json { render :show, status: :updated, location: @project}
      else
        format.html {
          params[:tab] = "settings"
          render :show, status: :unprocessable_entity
        }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def project_params
    case action_name
    when "create"
      params[:project] ||= {title: "Untitled"}
    end

    #We get email addresses in on params[:membership_attributes], and those need to be translated into user ids
    if params[:project][:members_attributes]
      params[:project][:members_attributes].each do |id, attrs|
        if user_from_email = User.where(:email => attrs[:email]).first
          attrs[:user_id] = user_from_email.id
        else #if we could not locate the user, we remove the membership attrs
          attrs.clear
          params[:project][:members_attributes].compact!
        end
      end
    end

    params.require(:project).permit(:id, :_destroy, :title,
      statuses_attributes: [:id, :_destroy, :name, :open, :order],
      members_attributes: [:id, :_destroy, :user_id, :project_id, :role]
      )
  end
end
