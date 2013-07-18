class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end
  
  
  def update
    @user = User.find(current_user.id)
    # remove the virtual current_password attribute update_without_password
    # doesn't know how to ignore it
    binding.pry
    params[:user].delete(:current_password) unless needs_password?(@user, params) 

    if (needs_password?(@user, params) ? @user.update_with_password(params[:user]) : @user.update_without_password(params[:user]))
      flash[:notice] = "Profile was updated successfully"
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
    end
    render "edit", :layout => 'application'
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    params[:user][:email].present?  && user.email != params[:user][:email] ||
      !params[:user][:password].blank?
  end

end
