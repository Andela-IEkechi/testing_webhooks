class TicketsController < ApplicationController
  include TicketsHelper

  before_filter :load_search_resources, :only => :index

  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :sprint,  :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :ticket,  :through => :project, :find_by => :scoped_id, :except => :index
  load_and_authorize_resource :overview

  before_filter :load_ticket_parents

  def index
    #get the search warmed up
    @search = scoped_tickets.search(RansackHelper.new(params[:q] && params[:q][:title_cont]).predicates)

    #figure out how to order the results
    sort_order = SortHelper.new(params[:q] && params[:q][:title_cont], current_user.preferences.ticket_order).sort_order
    sort_order = 'tickets.id' if sort_order.blank?

    results = @search.result.joins(:last_comment => [:sprint, :feature, :assignee, :status]).order(sort_order)

    @tickets = Kaminari::paginate_array(results).page(params[:page]).per(current_user.preferences.page_size.to_i) unless "false" == params[:paginate]
    @tickets ||= results

    @term = (params[:q] && params[:q][:title_cont] || '')

    @title = params[:title] if params[:title]
    @show_search = true unless params[:show_search] == 'false'


    @tickets_count = @tickets.count
    @tickets_cost = @tickets.map {|t| t.cost}.reduce(0, :+)
    @assignees_count = @tickets.collect(&:assignee).uniq.compact.count

    respond_to do |format|
      format.js do
        render :partial => '/shared/index'
      end
      format.html do
        redirect_to project_path(@project)
      end
    end
  end

  def show
    #create a new comment, but dont tell the ticket about it, or it will render
    @comment = Comment.new(:ticket_id   => @ticket.to_param,
                           :status_id   => @ticket.status.to_param,
                           :feature_id  => @ticket.feature_id, #use the real id here!
                           :sprint_id   => @ticket.sprint_id, #use the real id here!
                           :assignee_id => @ticket.assignee.to_param,
                           :cost        => @ticket.cost)
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
      if params[:create_another]
        flash.keep[:notice] = "Ticket was added. ##{@ticket.scoped_id} #{@ticket.title}"
        @ticket.reload #refresh the assoc to last_comment
        redirect_to new_project_ticket_path(@ticket.project, :feature_id => @ticket.feature, :sprint_id => @ticket.sprint)
      else
        flash.keep[:notice] = "Ticket was added"
        @ticket.reload # refresh the ID from the DB
        redirect_to project_ticket_path(@ticket.project, @ticket)
      end
    else
      flash[:alert] = "Ticket could not be created"
      @sprint = @ticket.sprint
      @feature = @ticket.feature
      render 'new'
    end
  end

  def edit
    @comment = @ticket.comments.first
  end

  def update
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = "Ticket was updated"
      redirect_to project_ticket_path(@ticket.project, @ticket)
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

  def load_search_resources
    if params[:q]
      [:project_id, :feature_id, :sprint_id, :assignee_id].each do |val|
        params[val] ||= params[:q][val] if params[:q][val] && !params[:q][val].empty?
        params[:q].delete(val)
      end
    end
  end

  def load_ticket_parents
    #if we dont pass the feature_id/sprint_id in on the url, we grab the ones from the ticket, if any
    if @ticket
      @sprint  ||= @ticket.sprint
      @feature ||= @ticket.feature
    end
  end

  #TODO: refactor this method
  def scoped_tickets
    return @sprint.assigned_tickets if @sprint
    return @feature.assigned_tickets if @feature
    return @project.tickets if @project
  end
end
