class LandingController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def home
  end

  def tour
  end

  def pricing
  end

  def signup
  end
end
