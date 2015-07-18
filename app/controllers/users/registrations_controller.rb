class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end


  def update
    # remove the virtual current_password attribute update_without_password
    # doesn't know how to ignore it
    params[:user]||= {}
    params[:user].delete(:current_password) unless needs_password?(resource, params)

    if (needs_password?(resource, params) ? resource.update_with_password(params[:user]) : resource.update_without_password(params[:user]))
      flash[:notice] = "Profile was updated successfully"
      # Sign in the user bypassing validation in case his password changed
      sign_in current_user, :bypass => true
    end

    if params[:memberships]
      #create new users based on membership attributes
      #the project owner has to be a member
      params[:memberships].each_pair do |id, role_hash|
        unless role_hash[:role].present?
          membership = Membership.where(:user_id => current_user.id).includes(:project).find(id)
          if membership.user_id != membership.project.user_id
            membership.destroy  #clean house if the member is removed
          end
        end
      end
      flash[:notice] = "Profile was updated successfully"
    end

    render "edit", :layout => 'application'
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  # added github_user.
  def needs_password?(user, params)
    (params[:user][:email].present? && user.email != params[:user][:email]) ||
    (params[:user][:github_user].present? && user.github_user != params[:user][:github_user]) ||
    !params[:user][:password].blank?
  end

end
