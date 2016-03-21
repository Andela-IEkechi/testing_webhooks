class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  #This allows us to pass these directly into redirect calls
  # e.g. redirect_to @foo, success: 'Foo was successfully created.'
  add_flash_types :success, :warning, :danger, :info

  before_action :load_resource
  before_action :clear_flash
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

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

end
