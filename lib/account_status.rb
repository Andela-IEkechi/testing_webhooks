module AccountStatus
  extend ActiveSupport::Concern

  included do
    before_filter :account_status, :except => [:index]

    private
    def account_status
      if ( @project.private && @project.blocked? )
        if (@project.user_id == current_user.id)
          flash[:alert] = "Project can not be accessed due to outstanding payment."
        else
          flash[:notice] = "Project is currently unavailable."
        end
        redirect_to projects_path
      end
    end
  end
end