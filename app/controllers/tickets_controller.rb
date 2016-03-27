class TicketsController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    respond_to do |format|
      format.json { render json: @tickets.to_json(include: [:status, :assignee, :user, :board])}
    end
  end

  private

  def load_resource
    @project = policy_scope(Project).find(params[:project_id])
    @resource_scope = @project.tickets
    super
  end

end
