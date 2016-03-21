class ApplicationController < ActionController::Base
  include Pundit

  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  #This allows us to pass these directly into redirect calls
  # e.g. redirect_to @foo, success: 'Foo was successfully created.'
  add_flash_types :success, :warning, :danger, :info

  before_action :load_resource
  before_action :clear_flash

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def clear_flash
    flash.clear
  end

  def load_resource
    klass = (controller_name.singularize.classify.constantize rescue nil)
    klass_name = (klass.name.underscore rescue nil)

    #if we are in a thing with a model. have a stab at loading it
    if klass
      @resource_scope ||= klass
      @resource_scope = policy_scope(@resource_scope)

      case action_name
      when 'index' then
        eval("@#{klass_name.pluralize} = @resource_scope.all")
      when 'show', 'edit', 'update', 'destroy' then
        eval("@#{klass_name} = @resource_scope.find(params[:id])")
      when 'new' then
        eval("@#{klass_name} = @resource_scope.new()")
      when 'create' then
        eval("@#{klass_name} = @resource_scope.new(#{klass_name}_params)")
      end
    end
  end

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
end
