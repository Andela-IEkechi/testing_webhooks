class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project
  load_and_authorize_resource :sprint, :through => :project
  load_and_authorize_resource :ticket

  before_filter :set_parents, :only => [:new, :create]

	def index
      @tickets = @feature.tickets if @feature
      @tickets ||= @project.tickets if @project
      @tickets ||= current_user.tickets
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
    @comment = @ticket.comments.build()
  end

  def create
    @ticket.comments.first.user = current_user
    if @ticket.save
      flash.keep[:info] = "Ticket was added"
      redirect_to ticket_path(@ticket, :project_id => @project.id, :feature_id => @feature.id)
    else
      flash[:alert] = "Ticket could not be created"
      @comment = Comment.new(:ticket_id => @ticket.id)
      render 'new'
    end
  end

  def edit
    @comment = @ticket.comments.first
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:info] = "Ticket was updated"
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

  def set_parents
    #must have a project to make a new ticket, optionally has a feature also
    @ticket.project = @project if @project
    @ticket.feature = @feature if @feature
    @ticket.sprint  = @sprint  if @sprint
  end

  def parent_path
    return project_sprint_path(@ticket.project, @ticket.sprint) if @ticket.belongs_to_sprint?
    return project_feature_path(@ticket.project, @ticket.feature) if @ticket.belongs_to_feature?
    project_path(@ticket.project)
  end

end
