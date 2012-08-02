class CommentsController < ApplicationController
  before_filter :load_ticket, :load_comment

  def index
      @comments = @ticket.comments if @ticket
      @comments ||= Comment.all
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
  end

  private
  def load_ticket
    if params[:ticket_id]
      @ticket = Ticket.find(params[:ticket_id])
    end
  end

  def load_comment
    if params[:id] #show/edit
      @comment = Comment.find(params[:id])
    elsif params[:comment] #create/update
      @comment = @ticket.comments.build(params[:comment]) if @ticket
      @comment ||= Comment.new(params[:comment])
    else #new
      @comment = @ticket.comments.build() if @ticket
      @comment ||= Comment.new()
    end
  end
end
