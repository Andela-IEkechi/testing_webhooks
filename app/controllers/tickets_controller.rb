class TicketsController < ApplicationController
	def index
		@tickets = Ticket.all
	end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new()
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    if @ticket.save
      flash[:info] = "Ticket was added"
      redirect_to ticket_path(@ticket)
    else
      flash[:alert] = "Ticket could not be created"
      render :template => 'new'
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])

    if @ticket.update_attributes(params[:ticket])
      flash[:info] = "Ticket was updated"
      redirect_to ticket_path(@ticket)
    else
      flash[:alert] = "Ticket could not be updated"
      render :template => 'edit'
    end

  end

  def destroy

  end
end
