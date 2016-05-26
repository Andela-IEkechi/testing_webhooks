class TicketsController < ApplicationController
  respond_to :json

  def index
    render json: @tickets
  end

  def show
    render json: @ticket
  end

  def new
    if @parent_comment = (Comment.find(params[:comment_id]) rescue nil)
      @comment.message = parent_comment_message(@parent_comment)
      @ticket.parent_id = @parent_comment.id
      render json: @ticket.to_json(include: :comments)
    end
  end

  def create
    if @ticket.valid? && @ticket.save
      #create a comment in the ticket for the current user
      @ticket.comments.create(commenter: current_user)
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
      :title
    )
  end

  def parent_comment_message(comment)
    text = "Split from [##{comment.ticket.sequential_id} - #{comment.ticket.title}](#{project_ticket_url(comment.ticket.project, comment.ticket)})\n\n---\n\n"
    text + comment.message
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
    when 'new' then
      @ticket = @resource_scope.build()
      authorize @ticket
      @comment = @ticket.comments.build()
    when 'create' then
      @ticket = @resource_scope.new(ticket_params)
      authorize @ticket
    end
  end  

end
