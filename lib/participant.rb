module Participant

  #figure out which participants not know to the app and make users for them (triggering an invite email)
  def create_from_params(project, participants_attrs)
    new_user_ids = []
    #for each new participant, look them up first, they might be a user already
    participants_attrs.each do |token, attrs|
      user = User.find_by_email(attrs[:email].downcase)
      unless user
        user = User.new(:email => attrs[:email].downcase)
        user.reset_authentication_token #so they can log in from the link we email them
        #we have to set a pasword, so we just make it the same as the token
        user.password = user.password_confirmation = user.authentication_token
        user.save #this should trigger emails to the user if they are new
        new_user_ids << user.id
      end
    end if participants_attrs
    new_user_ids
  end

  def notify(project, updated_participant_ids)
      #send out notifications to all the newly assigned participants
      new_participants.each do |id|
        user = User.find(id)
        AccessMailer.project_access_notification(user, project).deliver if user.confirmed?
      end
  end

end
