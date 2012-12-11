class CommentsController < ApplicationController
  before_filter :strip_empty_assets, :except => "ajax_update"
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

  def ajax_update
    @comment = Comment.find_by_id(params[:comment_id])
    @comment.body = params[:comment_body]
    @comment.cost = params[:comment_cost].to_i
    @comment.save
    respond_to do |format|
      format.js
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
