class TicketsController < ApplicationController
  respond_to :json

  def index
    render json: @tickets
  end

  def show
    render json: @ticket
  end

  def create
    # review note: Nope. if there is a comment id, it will be passed in with the other attributes for the form that submits for the new ticket
    # parent_comment = Comment.find(params[:comment_id]) if params[:comment_id]
    # @ticket.parent_id = parent_comment.id if parent_comment
    if @ticket.valid? && @ticket.save
      # for some reason nested attributes aint working via tickets params
      @ticket.comments.create(commenter: current_user,
                              status_id: params[:status_id],
                              assignee_id: params[:assignee_id],
                              message: params[:message])
      render json: @ticket
    else
      render json: {errors: @ticket.errors.full_messages}, status: 422
    end
  end

  def update
    if @ticket.update_attributes(ticket_params)
      render json: @ticket
    else
      render json: {errors: @ticket.errors.full_messages}, status: 422
    end    
  end

  def destroy
    if @ticket.delete
      render json: @ticket
    else
      render json: {errors: @ticket.errors.full_messages}, status: 422
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(
      :id, :_destroy,
      :title, :parent_id
    )
  end

  def load_resource
    #we have to load the project first
    @project = Project.friendly.find(params[:project_id])
    @resource_scope = policy_scope(@project.tickets)
    case action_name
    when 'index' then
      @tickets = @resource_scope.all
    when 'show', 'update', 'destroy' then
      # NOTE: we only ever use the sequential ID to find tickets
      @ticket = @resource_scope.where(sequential_id: params[:id]).first
      raise ActiveRecord::RecordNotFound unless @ticket.present? #the .where().first above won't throw an exception like .find(:id) does
      authorize @ticket
    when 'create' then
      @ticket = @resource_scope.new(ticket_params)
      authorize @ticket
    end
  end  

end
