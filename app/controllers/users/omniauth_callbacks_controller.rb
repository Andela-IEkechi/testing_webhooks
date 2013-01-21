class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_github_oauth(request.env["omniauth.auth"], current_user)
    p "git this user: #{user}"
    if @user.persisted?
      p "got a user, signing them in now."
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect @user, :event => :authentication
    else
      p "user not persisted... #{user.errors}"
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
