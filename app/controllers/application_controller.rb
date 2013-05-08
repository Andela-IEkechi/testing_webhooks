class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :after_token_authentication
  before_filter :authenticate_user!
  protect_from_forgery

  load_resource :project, :if => @current_user
  before_filter :load_membership

  helper_method :current_membership

  def current_membership
    @current_membership
  end

  protected

  def after_token_authentication
    if params[:authentication_key].present?
      @user = User.find_by_authentication_token(params[:authentication_key])
      sign_in @user if @user
    end
  end

  def layout_by_resource
    if devise_controller? && action_name != 'edit'
      "landing"
    else
      "application"
    end
  end

  #if there is a project in context, we need to load the membership of the current user
  def load_membership
    if @project && current_user
      @current_membership = @project.memberships.for_user(current_user.id).first
    else
      @current_membership = nil
    end
  end

end
