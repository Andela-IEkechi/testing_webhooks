class FeaturesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :feature, :through => :project, :find_by => :scoped_id

  def index
    redirect_to project_path(@project)
  end

  def show
  end

  def new
  end

  def create
    if @feature.save
      flash[:notice] = "Feature was added"
      redirect_to project_path(@feature.project)
    else
      flash[:alert] = "Feature could not be created"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @feature.update_attributes(params[:feature])
      flash[:notice] = "Feature was updated"
      redirect_to project_feature_path(@feature.project,@feature)
    else
      flash[:alert] = "Feature could not be updated"
      render :action => 'edit'
    end

  end

  def destroy
    if @feature.destroy
      redirect_to project_path(@project)
    else
      redirect_to project_feature_path(@project, @feature)
    end
  end

end
