class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project
  load_and_authorize_resource :sprint, :through => :project
  load_and_authorize_resource :ticket

  def index
    @tickets = nil
    @tickets = @sprint.assigned_tickets if @sprint
    @tickets ||= @feature.assigned_tickets if @feature
    @tickets ||= @project.tickets.all if @project
    if params[:assignee_id] && @tickets
      @tickets.select! do |t|
        t.assignee_id == params[:assignee_id].to_i
      end
      @assignee_id = current_user.id
    end
    @tickets = Kaminari.paginate_array(@tickets).page params[:page] if @tickets

    respond_to do |format|
      format.js do
        render :partial => '/shared/index'
      end
      format.html
    end
  end

  def show
    #create a new comment, but dont tell the ticket about it, or it will render
    @comment = Comment.new(
      :ticket_id => @ticket.id,
      :status_id => @ticket.status.try(:id),
      :feature_id => @ticket.feature.try(:id),
      :sprint_id => @ticket.sprint.try(:id),
      :assignee_id => @ticket.assignee.try(:id),
      :cost => @ticket.cost
      )
  end

  def new
    #must have a project to make a new ticket, optionally has a feature/sprint also
    @ticket.project = @project
    @comment = @ticket.comments.build()
    @comment.feature = @feature
    @comment.sprint  = @sprint
  end

  def create
    @ticket.comments.build() unless @ticket.comments.first
    @ticket.comments.first.user = current_user

    if @ticket.save
      flash.keep[:info] = "Ticket was added"
      redirect_to ticket_path(@ticket, :project_id => @ticket.project_id, :feature_id => @ticket.feature_id, :sprint_id => @ticket.sprint_id)
    else
      flash[:alert] = "Ticket could not be created"
      render 'new'
    end
  end

  def edit
    @comment = @ticket.comments.first
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = "Ticket was updated"
      redirect_to ticket_path(@ticket, :project_id => @project, :feature_id => @feature)
    else
      flash[:alert] = "Ticket could not be updated"
      render 'edit'
    end

  end

  def destroy
    delete_path = parent_path()
    if @ticket.destroy
      redirect_to delete_path
    else
      flash[:alert] = "Ticket could not be deleted"
      render 'show'
    end
  end

  private

  def parent_path
    return project_sprint_path(@ticket.project, @ticket.sprint) if @ticket.sprint
    return project_feature_path(@ticket.project, @ticket.feature) if @ticket.feature
    project_path(@ticket.project)
  end

end
