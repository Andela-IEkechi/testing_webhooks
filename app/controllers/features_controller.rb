class FeaturesController < ApplicationController
  before_filter :load_project

  def index
    @features = @project.features.all
  end

  def show
    @feature = @project.features.find(params[:id])
  end

  def new
    @feature = @project.features.build()
  end

  def create
    @feature = @project.features.build(params[:feature])
    if @feature.save
      flash[:info] = "Feature was added"
      redirect_to project_path(@feature.project)
    else
      flash[:alert] = "Feature could not be created"
      render :action => 'new'
    end
  end

  def edit
    @feature = @project.features.find(params[:id])
  end

  def update
    @feature = @project.features.find(params[:id])

    if @feature.update_attributes(params[:feature])
      flash[:info] = "Feature was updated"
      redirect_to project_feature_path(@feature.project,@feature)
    else
      flash[:alert] = "Feature could not be updated"
      render :action => 'edit'
    end

  end

  def destroy

  end

  private

  def load_project
    @project = Project.find(params[:project_id])
  end
end
