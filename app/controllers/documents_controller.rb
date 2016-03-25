class DocumentsController < ApplicationController
  def download
    authorize @document

    #use send_data while we host on s3
    # @document.file.set_content_type #please leave alone, this is to unfuck the test for documents controller
    send_data(@document.file.file.read, :filename => @document.file.local_name, :type => @document.file.local_content_type)
    #use send_file once the hosting is local
    # send_file(@document.file.file.read, :disposition => 'attachment', :url_based_filename => false)
  end

  private

  def load_resource
    super

    case action_name
    when "download"
      @document = @resource_scope.find(params[:id])
    end
  end
end
