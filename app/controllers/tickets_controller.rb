class TicketsController < ApplicationController
  respond_to :json

  def index
    render json: @tickets
  end

  def show
    render json: @ticket
  end

  #review notes: we should not implement new action, we have no views to render.
  #To split a ticket, we should create a new ticket and allow the user to edit it, instead of seeding a "new" form with the original tickt info
  # def new
  #   if @parent_comment = (Comment.find(params[:comment_id]) rescue nil)
  #     @comment.message = parent_comment_message(@parent_comment)
  #     @ticket.parent_id = @parent_comment.id
  #     render json: @ticket.to_json(include: :comments)
  #   end
  # end

  #review note: if we pass in a comment ID, then the ticket we are about to make is a split ticket. We dont need to do antuthg else here, just set the coment we belong to and leave it at that.
  def create
    if @ticket.valid? && @ticket.save
      #create a comment in the ticket for the current user
      #review note: just make sure the parent comment ID is set if we are a split ticket
      #review note: we need to make a comment that includes the ticket bodu, status etc that are all set on the comment.
      @ticket.comments.create(commenter: current_user) #<<-- this needs to inlcude all the coment attrs like assignee etc that were passed in.
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
      #review not, we need to accept the comment params also here
    )
  end

  #review note: we dont need this because we are not seeding the view, we assume th UI does the right thing and just send us the new ticket(comment) body
  # def parent_comment_message(comment)
  #   text = "Split from [##{comment.ticket.sequential_id} - #{comment.ticket.title}](#{project_ticket_url(comment.ticket.project, comment.ticket)})\n\n---\n\n"
  #   text + comment.message
  # end


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
    # review note: dont need this...
    # when 'new' then
    #   @ticket = @resource_scope.build()
    #   authorize @ticket
    #   @comment = @ticket.comments.build()
    when 'create' then
      @ticket = @resource_scope.new(ticket_params)
      authorize @ticket
    end
  end  

end
