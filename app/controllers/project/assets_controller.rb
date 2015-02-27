class Project::AssetsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :asset, :through => :project, :find_by => :scoped_id, :class => 'Project::Asset'

  def index
    redirect_to project_path(@project)
  end

  def show
  end

  def new
  end

  def create
    if @asset.save
      flash[:notice] = "Asset was added"
      redirect_to project_path(@asset.project)
    else
      flash[:alert] = "Asset could not be created"
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
    #user send_data while we host on s3
    send_data(@asset.payload.file.read, :filename => @asset.name, :type => @asset.payload.file.content_type)
    #use send_file once the hosting is local
    #send_file(@asset.payload, :disposition => 'attachment', :url_based_filename => false)
  end
end
