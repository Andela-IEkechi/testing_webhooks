class Users::RegistrationsController < Devise::RegistrationsController

  def destroy

    # TODO Implement this either as a real delete or as a soft-delete
    # resource.destroy

    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

end
