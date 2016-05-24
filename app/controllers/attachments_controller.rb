class AttachmentsController < ApplicationController
  respond_to :json

  def index
    render json: @attachments
  end

  def show
    render json: @attachment
  end

  def create
    @attachment = Attachment.new(attachment_params)
    if @attachment.valid? && @attachment.save
      render json: @attachment
    else
      render json: {errors: @attachment.errors.full_messages}, status: 422
    end
  end

  def update
    @attachment.update_attributes(attachment_params)
    if @attachment.valid? && @attachment.save
      render json: @attachment
    else
      render json: {errors: @attachment.errors.full_messages}, status: 422
    end
  end

  def destroy
    if @attachment.destroy
      render json: @attachment
    else
      render json: {errors: @attachment.errors.full_messages}, status: 422
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit(:file, :remove_file)
  end

  def load_resource
    @comment = Comment.find(:comment_id) if params[:comment_id]
    @resource_scope = policy_scope(@comment.attachments)
    super
  end
end
