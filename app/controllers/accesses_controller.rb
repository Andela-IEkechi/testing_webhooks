class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @participants = current_user.projects.collect(&:participants).flatten.uniq
  end

  def update
    new_user_ids = Participant::create_from_params(@project, params[:project].delete(:participants_attributes))
    params[:project][:participant_ids] = params[:project][:participant_ids].collect(&:to_i).select{|x| x > 0} + new_user_ids
    params[:project][:participant_ids].uniq!

    if @project.update_attributes(params[:project])
      Participant::notify(@project, params[:project][:participant_ids])
      flash[:notice] = "Project access updated"
      redirect_to edit_project_path(@project)
    else
      flash[:alert] = "Project access could not be updated"
      render '/projects/edit'
    end
  end
end
