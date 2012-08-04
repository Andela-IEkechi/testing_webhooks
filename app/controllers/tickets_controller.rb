class TicketsController < ApplicationController
  before_filter :load_ticketable, :load_ticket

	def index
      @tickets = @ticketable.tickets if @ticketable
      @tickets ||= Ticket.all
	end

  def show
  end

  def new
  end

  def create
    if @ticket.save
      flash[:info] = "Ticket was added"
      redirect_to ticket_path(@ticket)
    else
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

  private
  def load_ticketable
    if params[:ticketable_type] && params[:ticketable_id]
      #ticketable_type == 'Project / Feature ' etc
      ticketable_type = params[:ticketable_type].constantize
      @ticketable = ticketable_type.find(params[:ticketable_id])
    elsif params[:feature_id]
      @ticketable = Feature.find(params[:feature_id])
      @feature = @ticketable
      @project = @feature.project
    elsif params[:project_id]
      @ticketable = Project.find(params[:project_id])
      @project = @ticketable
    else
      @ticketable = nil
    end
  end

  def load_ticket
    if params[:id] #show/edit
      @ticket = Ticket.find(params[:id])
    elsif params[:ticket] #create/update
      @ticket = @ticketable.tickets.build(params[:ticket]) if @ticketable
      @ticket ||= Ticket.new(params[:ticket])
    else #new
      @ticket = @ticketable.tickets.build() if @ticketable
      @ticket ||= Ticket.new()
    end
  end
end
