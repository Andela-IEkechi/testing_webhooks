module Participant

  #figure out which participants not know to the app and make users for them (triggering an invite email)
  def self.create_from_params(project, participants_attrs={})
    new_user_ids = []
    #for each new participant, look them up first, they might be a user already
    participants_attrs.each do |token, attrs|
      user = User.find_by_email(attrs[:email].downcase)
      unless user || attrs[:email].blank? || attrs[:_destroy] == '1'
        user = User.new(:email => attrs[:email].downcase)
        user.reset_authentication_token #so they can log in from the link we email them
        #we have to set a pasword, so we just make it the same as the token
        user.password = user.password_confirmation = user.authentication_token
        user.save #this should trigger emails to the user if they are new
      end
      new_user_ids << user.id if user
    end if participants_attrs
    new_user_ids.compact
  end

  def self.notify(project, updated_participant_ids=[])
      #send out notifications to all the newly assigned participants
      updated_participant_ids.each do |id|
        user = User.find(id)
        AccessMailer.project_access_notification(user, project).deliver if user.confirmed? && !project.participant_ids.include?(id)
      end
  end

end
