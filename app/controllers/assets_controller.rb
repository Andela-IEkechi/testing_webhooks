class AssetsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :asset, :through => :project, :find_by => :scoped_id, :except => [:create]

  before_filter :process_multiple_assets, :only => [:create]

  def index
    redirect_to project_path(@project)
  end

  def show
  end

  def new
  end

  def create
    if ((params[:files].count rescue 0) > 0) && @project.save #implicitly save all the assets
      if (params[:files].count rescue 0) == 1
        flash[:notice] = "Asset was added"
      else
        flash[:notice] = "#{params[:files].count} assets were added"
      end
      redirect_to project_path(@project, :tab => 'assets')
    else
      @asset = @project.assets.general.new()
      flash[:alert] = "Asset(s) could not be added"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @asset.update_attributes(params[:asset])
      flash[:notice] = "Asset was updated"
      redirect_to project_asset_path(@asset.project,@asset)
    else
      flash[:alert] = "Asset could not be updated"
      render :action => 'edit'
    end

  end

  def destroy
    if @asset.destroy
      redirect_to project_path(@project)
    else
      redirect_to project_asset_path(@project, @asset)
    end
  end

  def download
    #for some inexplicable reason, cancan refuses to load the @asset instance on this action. I just can't tell why
    @asset = @project.assets.find_by_scoped_id(params[:asset_id])
    authorize! :download, @asset

    #user send_data while we host on s3
    send_data(@asset.payload.file.read, :filename => @asset.name, :type => @asset.payload.file.content_type)
    #use send_file once the hosting is local
    #send_file(@asset.payload, :disposition => 'attachment', :url_based_filename => false)
  end

  private

  def process_multiple_assets
    return unless params[:files]
    params[:files].each do |f|
      @project.assets.new(:payload => f)
    end
  end
end
