class LandingController < ApplicationController
  skip_before_filter :authenticate_user!

  def home
    if user_signed_in?
      redirect_to projects_path
    end
  end

  def tour
  end

  def pricing
    @plans = Account::PLANS.reject{|k,v| k == 'free'}
  end

  def signup
  end

  def support

  end

  def privacy

  end

  def terms

  end
end
