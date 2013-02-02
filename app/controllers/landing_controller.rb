class LandingController < ApplicationController
  skip_before_filter :authenticate_user!

  def home
  end

  def tour
  end

  def pricing
    @plans = Account::PLANS.reject{|k,v| k == 'free'}
  end

  def signup
  end
end
