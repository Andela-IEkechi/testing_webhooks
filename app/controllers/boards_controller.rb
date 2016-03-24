class BoardsController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def show
    authorize @board

    respond_to do |format|
      format.json { render json: @board.to_json(include: { tickets: {include: [:status, :assignee, :user]}})}
    end
  end

  private

  def load_resource
    @project = policy_scope(Project).find(params[:project_id])
    @resource_scope = @project.boards
    super
  end

end
