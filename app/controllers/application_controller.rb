class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_filter :authenticate_user!  
  protect_from_forgery

  protected

  def layout_by_resource
    if devise_controller? && action_name == 'new'
      "landing"
    else
      "application"  
    end
  end
end
