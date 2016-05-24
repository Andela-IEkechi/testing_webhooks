class HomeController < ApplicationController
  def index
    skip_policy_scope
    render :index
  end
end
