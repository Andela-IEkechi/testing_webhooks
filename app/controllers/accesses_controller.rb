class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @memberships = current_user.projects.collect(&:memberships).flatten.uniq.sort{|a,b| a.user_email <=> b.user_email}
  end

  def update
    #create new users based on membership attributes
    params[:project][:memberships_attributes].each do |token, membership_attr|
      user = User.find_by_email(membership_attrs[:email].downcase)
      user ||= User.invite!(:email => attrs[:email].downcase) unless attrs[:email].blank? || attrs[:_destroy] == '1'

      membership = @project.memberships.find_or_create_by_user_id(:user_id => user.id) if user
      membership.update_attributes(membership_attr) if membership
    end

    if @project.update_attributes(params[:project])
      flash[:notice] = "Project access updated"
      redirect_to edit_project_path(@project)
    else
      flash[:alert] = "Project access could not be updated"
      render '/projects/edit'
    end
  end
end

