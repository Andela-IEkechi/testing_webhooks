class WelcomeController < ApplicationController
  def home
    flash[:warning] = "this is a warning test"
  end

  def tour
    flash[:success] = "this is a success test"
  end

  def pricing
  end

  def support
  end

  def privacy
  end

  def terms_and_conditions
  end
end
