class CommentsController < ApplicationController
  load_and_authorize_resource :ticket
  load_and_authorize_resource :comment, :through => :ticket

  def new
  end

  def create
    @comment.user = current_user
    if @comment.save
      flash.keep[:notice] = "Comment was added"
      redirect_to ticket_path(@comment.ticket, :project_id => @comment.ticket.project, :feature_id => @comment.feature)
    else
      flash[:alert] = "Comment could not be created"
      @ticket = @comment.ticket
      render '/tickets/show'
    end
  end
end
