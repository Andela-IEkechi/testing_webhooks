class ProjectsController < ApplicationController

  def show
    authorize @project
  end

  private

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
