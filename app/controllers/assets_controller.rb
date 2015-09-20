class AssetsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, :through => :project, :find_by => :scoped_id
  load_and_authorize_resource :asset, :through => :project, :find_by => :scoped_id, :except => [:create]
  include AccountStatus

  before_filter :process_multiple_assets, :only => [:create]

  def index
    @assets = scoped_assets.search(@query).page(params[:page]).per(current_user.preferences.page_size.to_i)

    @show_search = true

    respond_to do |format|
      format.js do
        render :partial => '/shared/index'
      end
      format.html do
        redirect_to project_path(@project)
      end
    end
  end

  # def show
  # end

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
      redirect_to project_path(@asset.project, :tab => 'assets')
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

    #use send_data while we host on s3
    # @asset.payload.set_content_type #please leave alone, this is to unfuck the test for assets controller
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

  #TODO: refactor this method
  def scoped_assets
    return @sprint.assets.general if @sprint
    return @project.assets.general if @project
  end

end
