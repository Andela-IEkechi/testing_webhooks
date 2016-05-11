class TicketsController < ApplicationController
  respond_to :json

  def index
    render json: @tickets
  end

  def show
    render json: @ticket
  end

  # def create
  #   #TODO need to check if current_user MAY create a ticket
  #   if @ticket.valid? && @ticket.save
  #     #create a coment in the ticket for the current user
  #     comment = @ticket.comments.create(commenter: current_user)
  #     render json: @ticket
  #   else
  #     render json: {errors: @ticket.errors.full_messages}, status: 422
  #   end
  # end

  # def update
  #   @ticket.update_attributes(ticket_params)
  #   if @ticket.valid? && @ticket.save
  #     render json: @ticket
  #   else
  #     render json: {errors: @ticket.errors.full_messages}, status: 422
  #   end    
  # end

  # def delete
  #   if @ticket.delete?
  #     render json: @ticket
  #   else
  #     render json: {errors: @ticket.errors.full_messages}, status: 422
  #   end
  # end

  private

  def ticket_params
    params.require(:ticket).permit(
      :id, :_destroy,
      :name
    )
  end

  def load_resource
    #we have to load the project first
    @project = Project.friendly.find(params[:project_id])
    @resource_scope = @project.tickets if ['show', 'update', 'destroy', 'create'].include?(action_name) 
    super
  end  
end
