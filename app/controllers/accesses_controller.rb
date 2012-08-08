class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @participants = current_user.projects.collect(&:participants).flatten.uniq
  end

  def update
    new_participants_attrs = params[:project].delete(:participants_attributes)
    #for each new participant, look them up first, they might be a user already
    new_participants_attrs.each do |token, attrs|
      user = User.find_by_email(attrs[:email].downcase)
      unless user
        user = User.new(:email => attrs[:email].downcase)
        user.reset_authentication_token #so they can log in from the link we email them
        #we have to set a pasword, so we just make it the same as the token
        user.password = user.password_confirmation = user.authentication_token
        user.save #this should trigger emails to the user if they are new
      end
      #set the id of this user, so the proejct is linked with them when we update down below
      params[:project][:participant_ids] << user.id
      params[:project][:participant_ids].uniq!
    end if new_participants_attrs

    if @project.update_attributes(params[:project])
      flash[:notify] = "Project access updated"
      redirect_to edit_project_access_path(@project)
    else
      flash[:alert] = "Project access could not be updated"
      render 'edit'
    end
  end
end
