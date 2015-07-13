class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :payment_params #only realy used on non-production envs
  before_filter :after_token_authentication
  before_filter :authenticate_user!
  protect_from_forgery

  load_resource :project, :if => @current_user
  before_filter :load_membership

  helper_method :current_membership

  def current_membership
    @current_membership
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  protected

  def after_token_authentication
    if params[:authentication_token].present?
      @user = User.find_by_authentication_token(params[:authentication_token])
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

  def payment_params
    return true if Rails.env.production?

    #NOTE: on staging etc, we wont get the correct redirect, we have to do it ourselves.
    #2co wont redirect if the url we ask for does not match the registered url they have on their side.
    payment_url = params.delete("x_receipt_link_url")

    if payment_url
      redirect_to payment_url + "&" + params.to_query
    end
  end

end
