class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @memberships = current_user.projects.collect(&:memberships).flatten.uniq.sort{|a,b| a.user_email <=> b.user_email}
  end

  def update
    #create new users based on membership attributes
    #the project owner has to be a member
    params[:project][:memberships_attributes].each do |token, membership_attr|

      if membership_attr[:id]
        membership = Membership.find(membership_attr[:id])
        if membership_attr[:role] && membership_attr[:role].empty?
          membership.destroy  #clean house if the member is removed
        else
          user = membership.user
        end
      else
        user_attr = membership_attr[:user]
        user = User.find_by_email(user_attr[:email].downcase)
        user ||= User.invite!(:email => user_attr[:email].downcase) unless user_attr[:email].blank?
      end

      if user && (membership = @project.memberships.find_or_create_by_user_id(:user_id => user.id))
        membership.role = membership_attr[:role] if membership
        membership.save
      end
    end

    flash[:notice] = "Project access updated"
    redirect_to edit_project_path(@project)
  end
end

