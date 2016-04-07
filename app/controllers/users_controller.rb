class UsersController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def edit
    authorize @user
    p @user.preferences
  end

  def update
    authorize @user

    @user.update_attributes(user_params)

    respond_to do |format|
      format.html {redirect_to edit_user_path(@user)}
    end
  end

  private

  def user_params
    # transfer temporary attrs to the preferences hash
    params[:user][:preferences] = {}
    [:page_size, :ticket_order, :project_tab].each do |pref|
      params[:user][:preferences][pref] = params[:user].delete(pref)
    end

    params.require(:user).permit(
      :id, :_destroy,
      preferences: [:page_size, :ticket_order, :project_tab],
      integration_attributes: [:id, :_destroy, :party, :enabled, :key]
    )
  end
end
