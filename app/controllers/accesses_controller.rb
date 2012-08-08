class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @participants = current_user.projects.collect(&:participants).flatten.uniq
  end

  def update
    new_participants_attrs = params[:project].delete(:participants_attributes)
    new_participants = []
    #for each new participant, look them up first, they might be a user already
    p "new_participants_attrs: #{new_participants_attrs}"
    new_participants_attrs.each do |token, attrs|
      user = User.find_by_email(attrs[:email].downcase)
      p "found user #{attrs[:email]}? #{user}"
      unless user
        user = User.new(:email => attrs[:email].downcase)
        user.reset_authentication_token #so they can log in from the link we email them
        #we have to set a pasword, so we just make it the same as the token
        user.password = user.password_confirmation = user.authentication_token
        user.save #this should trigger emails to the user if they are new
      end
      #set the id of this user, so the proejct is linked with them when we update down below
      params[:project][:participant_ids] << user.id.to_s #params are strings
      params[:project][:participant_ids].uniq!
    end if new_participants_attrs

    p "current ones: #{@project.participants.collect(&:id)}"
    p "assigned participants: #{params[:project][:participant_ids]}"
    params[:project][:participant_ids].select!{|x| !x.empty?}.collect!(&:to_i)
    p "converted participants: #{params[:project][:participant_ids]}"

    new_participants = params[:project][:participant_ids] - @project.participants.collect(&:id)
    p "new participants: #{new_participants}"

    if @project.update_attributes(params[:project])
      #send out notifications to all the new participants
      new_participants.each do |id|
        AccessMailer.project_access_notification(User.find(id),@project).deliver unless id.blank?
      end

      flash[:notify] = "Project access updated"
      redirect_to edit_project_access_path(@project)
    else
      flash[:alert] = "Project access could not be updated"
      render 'edit'
    end
  end
end
