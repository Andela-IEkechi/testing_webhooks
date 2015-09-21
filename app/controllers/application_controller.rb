class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :payment_params #only realy used on non-production envs
  before_filter :after_token_authentication
  before_filter :authenticate_user!
  protect_from_forgery

  extend SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler
  acts_as_token_authentication_handler_for User, :fallback_to_devise => false #needs to be false to allow access to landing page links

  load_resource :project, :if => @current_user
  before_filter :load_membership
  before_filter :process_search_query

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

  def process_search_query
    @query = params[:search][:query].to_s rescue params[:query].to_s
    #split it on spaces
    result = {
      :ticket => [],
      :sprint => [],
      :status => [],
      :cost => [],
      :assigned => [],
      :tag => []
    }
    return result unless @query.present?
    parts = @query.downcase.split(' ')
    parts.each do |part|
      #see if we have a known key like foo:bar
      k,v = part.split(':')
      if k.present? && v.present?
        if ('sprint' =~ /^#{k}/).present?
          result[:sprint] << v
        elsif ('status' =~ /^#{k}/).present?
          result[:status] << v
        elsif ('cost' =~ /^#{k}/).present?
          result[:cost] << v
        elsif ('assignee' =~ /^#{k}/).present? || ('assigned' =~ /^#{k}/).present? #'assign' will also match here
          result[:assigned] << v
        elsif ('tags' =~ /^#{k}/).present? # 'tag' will also match here
          result[:tag] << v
        end
      elsif k.present?
        result[:ticket] << k
      end
    end
    return result
  end
end
