class AttachmentsController < ApplicationController
  respond_to :json

  def index
    render json: @attachments
  end

  def show
    render json: @attachment
  end

  def attach_file_to_comment
    return unless params[:file]
    @attachment = Attachment.new
    @attachment.comment = @comment
    authorize @attachment
    @attachment.file = StringIO.new(params[:file])
    @attachment.save
    render json: @attachment
  end

  def remove_file_from_comment
    return unless params[:file]
    @attachment = Attachment.new
    @attachment.comment = @comment
    authorize @attachment
    @attachment.file = StringIO.new(params[:file])
    @attachment.remove_file = true
    @attachment.save
    render json: @attachment
  end

  private

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @ticket = @project.tickets.find(params[:ticket_id])
    @comment = @ticket.comments.find(params[:comment_id])
    @resource_scope = policy_scope(@comment.attachments)
    super
  end
end
