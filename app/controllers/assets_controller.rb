class AssetsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :asset, :through => :ticket, :class => 'Comment::Asset'

  def download
    @asset = @ticket.assets.find(params[:asset_id])
    #user send_data while we host on s3
    send_data(@asset.payload.file.read, :filename => @asset.name, :type => @asset.payload.file.content_type)
    #use send_file once the hosting is local
    #send_file(@asset.payload, :disposition => 'attachment', :url_based_filename => false)
  end

end
