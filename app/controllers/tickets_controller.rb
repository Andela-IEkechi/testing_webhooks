class TicketsController < ApplicationController
  before_filter :load_project, :load_feature, :load_ticket

	def index
      @tickets = @feature.tickets if @feature
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

  def load_project
    @project = Project.find(params[:project_id]) if params[:project_id]
    @project ||= nil
  end

  def load_feature
    @feature = @project.features.find(params[:feature_id]) if @project && params[:feature_id]
    @feature ||= Feature.find(params[:feature_id]) if params[:feature_id]
    @feature ||= nil
  end

  def load_ticket
    if params[:id]
      @ticket = @feature.tickets.find(params[:id]) if @feature
      @ticket ||= Ticket.find(params[:id])
    elsif params[:ticket]
      @ticket = @feature.tickets.build(params[:ticket]) if @feature
      @ticket ||= Ticket.new(params[:ticket])
    else
      @ticket = @feature.tickets.build() if @feature
      @ticket ||= Ticket.new()
    end
  end
end
