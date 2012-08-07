class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :feature
  load_and_authorize_resource :ticket

	def index
      @tickets = @feature.tickets if @feature
      @tickets ||= @project.tickets if @project
      @tickets ||= current_user.tickets
	end

  def show
  end

  def new
    @ticket.comments.build()
  end

  def create
    if @ticket.save
      flash[:info] = "Ticket was added"
      redirect_to ticket_path(@ticket)
    else
      @project ||= @ticket.ticketable if @ticket.ticketable_type == 'Project'
      @feature ||= @ticket.ticketable if @ticket.ticketable_type == 'Feature'
      flash[:alert] = "Ticket could not be created"
      render :action => 'new'
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
      render :action => 'edit'
    end

  end

  def destroy

  end
end
