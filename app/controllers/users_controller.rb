class UsersController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def edit
    authorize @user

  end

  def update
    authorize @user
  end

  private

  def user_params
    params.require(:user).permit(
      :id, :_destroy,
      preferences: {},
      integration_attributes: [:id, :_destroy, :party, :enabled, :key]
    )
  end
end
