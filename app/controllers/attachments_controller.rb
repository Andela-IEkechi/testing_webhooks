class AttachmentsController < ApplicationController
  respond_to :json

  def index
    render json: @attachments
  end

  def show
    render json: @attachment
  end

  # review note: this should be "create"
  # should be normal create action
  def attach_file_to_comment
    return unless params[:file] #review note: dont agree here, we should always return the object, even if we could not succesfully make it
    @attachment = Attachment.new
    @attachment.comment = @comment
    authorize @attachment #gets called on super load_resource on "create"
    @attachment.file = StringIO.new(params[:file])
    @attachment.save

    render json: @attachment
  end

  # review note: this should be "destroy"
  # should be normal destroy
  def remove_file_from_comment
    return unless params[:file]
    @attachment = Attachment.new
    @attachment.comment = @comment
    authorize @attachment #gets call in super for load_resource on "destroy"
    @attachment.file = StringIO.new(params[:file])
    @attachment.remove_file = true #review note: we dont remove the file, we trash the entire attachment model
    @attachment.save
    render json: @attachment
  end

  # review note: we need to add a download action that uses something like send_file or send_data (find out which one)
  def download
    # send the file content down here
    # send_data(@attachment.file.read, :filename => @attachment.filename, :type => @attachment.file.content_type)
  end

  private

  # review note: neeed to att params whitelist like below
  # def attachment_params
  #   params.require(:attachment).permit(
  #       :id, :_destroy, :file
  #   )
  # end

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @ticket = @project.tickets.find(params[:ticket_id])
    @comment = @ticket.comments.find(params[:comment_id])
    @resource_scope = policy_scope(@comment.attachments)
    #review note:  add a download action to lod the attachment
    super
  end
end
