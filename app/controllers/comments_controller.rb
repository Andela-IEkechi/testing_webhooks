class CommentsController < ApplicationController
  load_and_authorize_resource :ticket
  load_and_authorize_resource :comment, :through => :ticket

  def index
  end

  def create
    if @comment.save
      flash[:info] = "Comment was added"
      redirect_to ticket_path(@ticket)
    else
      flash[:alert] = "Comment could not be created"
      render :controller => 'tickets', :action => 'show'
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:info] = "Comment was updated"
      redirect_to ticket_comment_path(@comment)
    else
      flash[:alert] = "Comment could not be updated"
      render :action => 'edit'
    end

  end

  def destroy
    if @comment.destroy
      redirect_to ticket_path(@ticket)
    else
      flash[:alert] = "Comment could not be deleted"
      redirect_to ticket_path(@ticket)
    end
  end

end
