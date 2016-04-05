class TicketsController < ApplicationController
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    respond_to do |format|
      format.json { render json: @tickets.all.map{|ticket| ticket.broadcast_data.merge(edit_url: edit_project_ticket_path(@project, ticket))}}
    end
  end

  def edit
    authorize @ticket
    respond_to do |format|
      format.html {render :edit}
    end
  end

  def update
    authorize @ticket
    binding.pry
    if @ticket.update_attributes(ticket_params)
      respond_to do |format|
        format.html {redirect_to edit_project_ticket_path(@project, @ticket)}
      end
    end
  end

  private

  def load_resource
    @project = policy_scope(Project).find(params[:project_id])
    @resource_scope = @project.tickets
    super
  end

  def ticket_params
    params.require(:ticket).permit(:id, :_destroy,
      comments_attributes: [:id, :_destroy, :user_id, :assignee_id, :cost, :status_id, :board_id, :content, documents_attributes: [:file]]
      )
  end

end
