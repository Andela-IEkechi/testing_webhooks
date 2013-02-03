class TicketsController < ApplicationController
  before_filter :load_search_resources, :only => :index

  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :sprint,  :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :ticket,  :through => :project, :find_by => :scoped_id, :except => :index

  before_filter :load_ticket_parents

  def index
    redirect_to project_path(@project) && return unless @project

    @tickets = @sprint.assigned_tickets if @sprint
    @tickets ||= @feature.assigned_tickets if @feature
    @tickets ||= @project.tickets if @project

    @tickets = @tickets.for_assignee_id(current_user.id) if params[:assignee_id]
    @assignee_id = current_user.id if params[:assignee_id]

    #also include tickets with IDs that match
    @search = @tickets.search(params[:search])
    @combined_search = @search.all

    #remember not to search for blank IDs, it will find '%%' matches, which deplicates results: con671
    @combined_search += @tickets.search_by_partial_id(params[:search].values.first) if params[:search] && !params[:search].values.first.blank?

    #need to resort both because we added to the set, and because metasearch seems to kill the model ordering
    @combined_search.sort!{|a,b| a.id<=>b.id}
    @tickets = Kaminari::paginate_array(@combined_search).page(params[:page])

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
    @comment = Comment.new(:ticket_id   => @ticket.scoped_id,
                           :status_id   => @ticket.status.try(:id),
                           :feature_id  => @ticket.feature.try(:id),
                           :sprint_id   => @ticket.sprint.try(:id),
                           :assignee_id => @ticket.assignee.try(:id),
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
      flash.keep[:notice] = "Ticket was added"
      if params[:create_another]
        @ticket.reload #refresh the assoc to last_comment
        redirect_to new_project_ticket_path(@ticket.project, :feature_id => @ticket.feature_id, :sprint_id => @ticket.sprint_id)
      else
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
    if params[:search]
      [:project_id, :feature_id, :sprint_id, :assignee_id].each do |val|
        params[val] ||= params[:search][val] if params[:search][val] && !params[:search][val].empty?
        params[:search].delete(val)
      end
    end
  end

  def load_ticket_parents
    #if we dont pass the feature_id/sprint_id in on the url, we grab the ones from the ticket, if any
    if @ticket
      @sprint ||= @ticket.sprint
      @feature ||= @ticket.feature
    end
  end

end
