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
    @tickets = filtered_tickets.includes(:last_comment => [:sprint, :status]).page(params[:page]).per(current_user.preferences.page_size.to_i)

    @term = (params[:search][:query] rescue '')

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

  def process_search_params(term)
    #split it on spaces
    result = {
      :ticket => [],
      :sprint => [],
      :status => [],
      :cost => [],
      :assigned => [],
      :tag => []
    }
    return result unless term.present?

    parts = term.downcase.split(' ')
    parts.each do |part|
      #see if we have a known key like foo:bar
      k,v = part.split(':')
      if k.present? && v.present?
        elsif ('sprint' =~ /^#{k}/).present?
          result[:sprint] << v
        elsif ('status' =~ /^#{k}/).present?
          result[:status] << v
        elsif ('cost' =~ /^#{k}/).present?
          result[:cost] << v
        elsif ('assign' =~ /^#{k}/).present?
          result[:assigned] << v
        elsif ('tag' =~ /^#{k}/).present?
          result[:tag] << v
        end
      elsif k.present?
        result[:ticket] << k
      end
    end
    return result
  end

  def filtered_tickets
    search_params = process_search_params((params[:search][:query] rescue ''))
    #filter tickets
    tickets = scoped_tickets
    if search_params[:ticket].any?
      #get all the tickets we are interested in
      search_params[:ticket].each { |s|
        tickets = tickets.search(s)
      }
    end
    #filter tickets by sprint
    if search_params[:sprint].any? && @sprint.blank? #no point in double filtering
      #get all the sprints we are limited to
      sprints = @project.sprints
      search_params[:sprint].each { |s|
        sprints = sprints.search(s)
      }
    end
    #filter tickets by status
    if search_params[:status].any?
      #get all the statuses we are limited to
      statuses = @project.ticket_statuses
      search_params[:status].each { |s|
        statuses = statuses.search(s)
      }
    end
    #filter tickets by comments
    comments = @project.comments.where(:id => tickets.select(:last_comment_id).collect(&:last_comment_id)) #limit them to the tickets that al least match
    if search_params[:cost].any? || search_params[:tag].any?
      #get all the assignees we are limited to
      combined = [search_params[:cost]] + [search_params[:tag]]
      combined.flatten!.compact!
      combined.each { |s|
        comments = comments.search(s)
      }
    end
    #filter tickets by assignee
    if search_params[:assigned].any?
      assignee_ids = comments.collect(&:assignee_id)
      #get all the assignees we are limited to
      assignees = User.where(:id => assignee_ids)
      search_params[:assigned].each { |s|
        assignees = assignees.search(s)
      }
    end
    #now we limit the comments to those who have the required values set
    comments = comments.where(:sprint_id => sprints.collect(&:id)) if sprints.present?
    comments = comments.where(:status_id => statuses.collect(&:id)) if statuses.present?
    comments = comments.where(:assignee_id => assignees.collect(&:id)) if assignees.present?
    @project.tickets.where(:id => comments.collect(&:ticket_id))
  end
end
