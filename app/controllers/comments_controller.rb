class CommentsController < ApplicationController
  before_filter :strip_empty_assets, :except => ["edit","destroy"]

  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :comment, :through => :ticket

  before_filter :set_feature_and_sprint, :only => [:create, :update]

  def new
  end

  def create
    @comment.user = current_user

    if @comment.save
      flash.keep[:notice] = "Comment was added"
    else
      flash[:alert] = "Comment could not be created"
      @ticket = @comment.ticket
    end

    redirect_to project_ticket_path(@comment.project, @comment.ticket)
  end

  def edit

  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment was updated"
      redirect_to project_ticket_path(@comment.project, @comment.ticket)
    else
      flash[:alert] = "Comment could not be updated"
      render 'edit'
    end
  end

  def destroy
    delete_path = project_ticket_path(@comment.project, @comment.ticket)
    if @comment.only?
      flash[:alert] = "Cannot remove the only comment"
    elsif @comment.destroy
      @removed_comment_id = params[:id]
      flash[:notice] = "Comment was removed"
    else
      flash[:alert] = "Comment could not be deleted"
    end
    respond_to do |format|
      format.html do
        redirect_to delete_path
      end
      format.js do
        render :partial => '/shared/destroy'
      end
    end

  end

  private
  def strip_empty_assets
    params[:comment][:assets_attributes] ||= []
    params[:comment][:assets_attributes].each do |id, attrs|
      params[:comment][:assets_attributes].delete(id) unless attrs[:payload]
    end
  end

  #used to set the current sprint and feature of a ticket if a regular user comments on it.
  #regular users are not allowed to change the sprint/feature assignment, so the fields are not passed back,
  #causing it to unintentionally un-assigned if not for this.
  def set_feature_and_sprint
    if cannot? :manage, @project
      @comment.feature = @ticket.feature
      @comment.sprint = @ticket.sprint
    end
  end
end
