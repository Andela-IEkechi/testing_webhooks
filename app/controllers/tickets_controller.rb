class TicketsController < ApplicationController
  include TicketsHelper

  before_filter :clear_assets_attributes, :only => [:create, :update]

  load_and_authorize_resource :project
  load_and_authorize_resource :sprint,  :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :ticket,  :through => :project, :find_by => :scoped_id, :except => :index
  load_and_authorize_resource :overview

  before_filter :load_ticket_parents
  include AccountStatus

  def index
    @sprint ||= (@project.sprints.find_by_scoped_id(params[:search][:sprint_id]) rescue nil)
    @tickets = filtered_tickets.includes(:last_comment => [:sprint, :status])
    #sort correctly
    @tickets = @tickets.reorder("tickets.id #{current_user.preferences.ticket_order || 'ASC'}")

    #paginate
    @tickets = @tickets.page(params[:page]).per(current_user.preferences.page_size.to_i)

    @title = params[:title] if params[:title]
    @show_search = true unless params[:show_search] == 'false'

    last_comments = Comment.select([:id, :cost, :assignee_id]).where(:id => @tickets.select(:last_comment_id).collect(&:last_comment_id))
    @tickets_count = last_comments.count
    @tickets_cost = last_comments.sum(:cost)
    @assignees_count = last_comments.collect(&:assignee_id).uniq.compact.count

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
                           :sprint_id   => @ticket.sprint_id, #use the real id here!
                           :assignee_id => @ticket.assignee.to_param,
                           :cost        => @ticket.cost)
  end

  def new
    #must have a project to make a new ticket, optionally has a sprint also
    @ticket.project = @project
    @comment = @ticket.comments.build()
    @comment.sprint  = @sprint
  end

  def create
    @ticket.comments.build() unless @ticket.comments.first
    @ticket.comments.first.user = current_user

    if @ticket.save
      params[:files].each do |f|
        @ticket.comments.first.assets.create(:payload => f, :project_id => @ticket.project_id)
      end if params[:files]

      if params[:create_another]
        flash.keep[:notice] = "Ticket was added. ##{@ticket.scoped_id} #{@ticket.title}"
        @ticket.reload #refresh the assoc to last_comment
        redirect_to new_project_ticket_path(@ticket.project, :sprint_id => @ticket.sprint)
      else
        flash.keep[:notice] = "Ticket was added"
        @ticket.reload # refresh the ID from the DB
        redirect_to project_ticket_path(@ticket.project, @ticket)
      end
    else
      flash[:alert] = "Ticket could not be created"
      @sprint = @ticket.sprint
      render 'new'
    end
  end

  def edit
    @comment = @ticket.comments.first
  end

  def update
    if @ticket.update_attributes(params[:ticket])

      params[:files].each do |f|
        @ticket.comments.first.assets.create(:payload => f, :project_id => @ticket.project_id)
      end if params[:files]

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
    project_path(@ticket.project)
  end

  def load_ticket_parents
    #if we dont pass the sprint_id in on the url, we grab the ones from the ticket, if any
    if @ticket
      @sprint  ||= @ticket.sprint
    end
  end

  #TODO: refactor this method
  def scoped_tickets
    return @sprint.assigned_tickets if @sprint
    return @project.tickets if @project
  end

  def clear_assets_attributes
    params[:ticket][:comments_attributes][:'0'].delete(:assets_attributes) if (params[:ticket][:comments_attributes][:'0'] rescue false)
  end

  def filtered_tickets
    comments = Comment.where(:id => scoped_tickets.collect(&:last_comment_id))
    filtered_comment_ids = comments.collect(&:id)

    process_search_query.each do |modifier, context, value|
      ids = case context
      when :ticket
        scoped_tickets.where{sift :search, value}.collect(&:last_comment_id)
      when :sprint
        sprint_ids = @project.sprints.where{sift :search, value}.collect(&:id)
        comments.where(:sprint_id => sprint_ids).collect(&:id)
      when :cost
        comments.where(:cost => value).collect(&:id)
      when :assigned
        user_ids = @project.users.where{sift :search, value}.collect(&:id)
        comments.where(:assignee_id => user_ids).collect(&:id)
      when :tag
        comments.tagged_with(value).collect(&:id)
      when :status
        status_ids = @project.ticket_statuses.where{sift :search, value}.collect(&:id)
        comments.where(:status_id => status_ids).collect(&:id)
      end
      if :and == modifier
        filtered_comment_ids = filtered_comment_ids & ids
      else #must be :or then
        filtered_comment_ids = filtered_comment_ids | ids
      end
    end

    ticket_ids = Comment.where(:id => filtered_comment_ids).collect(&:ticket_id)
    Ticket.where(:id => ticket_ids)
  end
end
