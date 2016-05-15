class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :load_resource
  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  def not_found(exception)
    respond_to do |format|
      h = { :status => "error", :message => exception.message }
      format.json { render :json => h, :status => :not_found }
      format.html { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
    end
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to request.headers["Referer"] || root_path
  end
  
  private

  def load_resource
    klass = (controller_name.singularize.classify.constantize rescue nil)
    klass_name = (klass.name.demodulize.underscore rescue nil)
    #if we are in a thing with a model, have a stab at loading it
    if klass
      @resource_scope ||= klass
      @resource_scope = policy_scope(@resource_scope)
      case action_name
      when 'index' then
        eval("@#{klass_name.pluralize} = @resource_scope.all")
      when 'show', 'update', 'destroy' then
        eval("@#{klass_name} = @resource_scope.find(params[:id])")
        eval("authorize @#{klass_name}")
      when 'create' then
        eval("@#{klass_name} = @resource_scope.new(#{klass_name}_params)")
        eval("authorize @#{klass_name}")
      end
    end
  end
  
end
