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
    # override in controllers
  end
end
