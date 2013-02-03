class SprintsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :sprint, :through => :project, :find_by => :scoped_id

  def index
    redirect_to project_path(@project)
  end

  def show
  end

  def new
    todays_date = Date.today
    @sprint.due_on = todays_date + (5 - todays_date.cwday) % 7
  end

  def create
    if @sprint.save
      flash[:notice] = "Feature was added"
      redirect_to project_path(@sprint.project)
    else
      flash[:alert] = "Feature could not be created"
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @sprint.update_attributes(params[:sprint])
      flash[:notice] = "Feature was updated"
      redirect_to project_sprint_path(@sprint.project,@sprint)
    else
      flash[:alert] = "Feature could not be updated"
      render :action => 'edit'
    end

  end

  def destroy
    if @sprint.destroy
      redirect_to project_path(@project)
    else
      redirect_to project_sprint_path(@project, @sprint)
    end
  end
end
