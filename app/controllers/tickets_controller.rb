class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project
  load_and_authorize_resource :ticket

  before_filter :set_parents, :only => [:new, :create]

	def index
      @tickets = @feature.tickets if @feature
      @tickets ||= @project.tickets if @project
      @tickets ||= current_user.tickets
	end

  def show
    redirect_to parent_path()
  end

  def new
    @ticket.comments.build()
  end

  def create
    if @ticket.save
      flash[:info] = "Ticket was added"
      redirect_to show_path
    else
      flash[:alert] = "Ticket could not be created"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:info] = "Ticket was updated"
      redirect_to ticket_path(@ticket)
    else
      flash[:alert] = "Ticket could not be updated"
      render 'edit'
    end

  end

  def destroy
  end

  private

  def set_parents
    #must have a project to make a new ticket, optionally has a feature also
    @ticket.project = @project
    @ticket.feature = @feature
  end

  def parent_path
    return project_feature_path(@ticket.project, @ticket.feature) if @ticket.feature
    return project_path(@ticket.project) if @ticket.project
    tickets_path()
  end

  def show_path
    return project_feature_ticket_path(@ticket.project, @ticket.feature, @ticket) if @ticket.feature
    return project_ticket_path(@ticket.project, @ticket) if @ticket.project
    ticket_path(@ticket)
  end
end
