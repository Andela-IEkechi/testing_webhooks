class WelcomeController < ApplicationController
  skip_after_action :verify_authorized, except: :index
  skip_after_action :verify_policy_scoped, only: :index

  def home
  end

  def tour
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
