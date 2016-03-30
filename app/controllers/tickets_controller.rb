class TicketsController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    respond_to do |format|
      format.json { render json: @tickets.all.map{|ticket| ticket.broadcast_data.merge(edit_url: edit_project_ticket_path(@project, ticket))}}
    end
  end

  private

  def load_resource
    @project = policy_scope(Project).find(params[:project_id])
    @resource_scope = @project.tickets
    super
  end

end
