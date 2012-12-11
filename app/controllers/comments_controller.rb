class CommentsController < ApplicationController
  before_filter :strip_empty_assets, :except => "edit"
  load_and_authorize_resource :ticket
  load_and_authorize_resource :comment, :through => :ticket


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

   redirect_to ticket_path(@comment.ticket, :project_id => @comment.ticket.project, :feature_id => @comment.feature)
  end

  def edit
    
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment was updated"
      redirect_to ticket_path(@comment.ticket)
    else
      flash[:alert] = "Comment could not be updated"
      render 'edit'
    end
  end

  private
  def strip_empty_assets
    params[:comment][:assets_attributes] ||= []
    params[:comment][:assets_attributes].each do |id, attrs|
      params[:comment][:assets_attributes].delete(id) unless attrs[:payload]
    end
  end
end
