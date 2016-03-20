class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  #This allows us to pass these directly into redirect calls
  # e.g. redirect_to @foo, success: 'Foo was successfully created.'
  add_flash_types :success, :warning, :danger, :info

  before_action :clear_flash


  private

  def clear_flash
    flash.clear
  end
end
