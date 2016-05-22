class CommentsController < ApplicationController
  respond_to :json

  def index
    render json: @comments.to_json(include: :previous)
  end

  def show
    render json: @comment.to_json(include: :previous)
  end

  def create
    @comment.commenter = current_user
    if @comment.valid? && @comment.save
      render json: @comment.to_json(include: :previous)
    else
      render json: {errors: @comment.errors.full_messages}, status: 422
    end
  end

  def update
    @comment.update_attributes(comment_params)
    if @comment.valid? && @comment.save
      render json: @comment.to_json(include: :previous)
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
        :message, :tag_list
    )
  end

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @ticket = @project.tickets.find(params[:project_id])
    @resource_scope = policy_scope(@ticket.comments)
    case action_name
      when 'index' then
        @comments = @resource_scope.all
      when 'show', 'update', 'destroy' then
        @comment = @resource_scope.where(id: params[:id]).first
        raise ActiveRecord::RecordNotFound unless @comment.present?
        authorize @comment
      when 'create' then
        @comment = @resource_scope.new(comment_params)
        authorize @comment
    end
  end
end
