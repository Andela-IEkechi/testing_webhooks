class CommentsController < ApplicationController
  respond_to :json

  def index
    render json: @comments.to_json
  end

  def show
    render json: @comment.to_json
  end

  def create
    @comment.commenter = current_user
    if @comment.valid? && @comment.save
      render json: @comment.to_json
    else
      render json: {errors: @comment.errors.full_messages}, status: 422
    end
  end

  def update
    @comment.update_attributes(comment_params)
    if @comment.valid? && @comment.save
      render json: @comment.to_json
    else
      render json: {errors: @comment.errors.full_messages}, status: 422
    end
  end

  def destroy
    if @comment.destroy
      render json: @comment
    else
      render json: {errors: @comment.errors.full_messages}, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(
        :id, :assignee_id, :commenter_id, :ticket_id, :status_id, :_destroy,
        :message
    )
  end

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @ticket = @project.tickets.find(params[:ticket_id])
    @resource_scope = policy_scope(@ticket.comments)
    super  #review note: this should be fine, we are not doing anything odd in loading up the resources
  end
end
