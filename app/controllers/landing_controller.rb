class LandingController < ApplicationController
  skip_before_filter :authenticate_user!

  layout 'landing'

  def home
    if user_signed_in?
      redirect_to projects_path
    end
  end

  def tour
  end

  def pricing
    @plans = Plan::PLANS.reject{|k,v| k == 'free'}
  end

  def support
  end

  def privacy
  end

  def terms
  end
end
