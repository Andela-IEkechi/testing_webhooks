class KeysController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @api_keys = @project.api_keys
  end

  def update
    #create new api_keys
    params[:project].delete(:api_keys_attributes).each do |id, api_key|
      unless api_key[:_destroy] == '1'
        #create new keys for all the new values
        #leave existing keys alone
        binding.pry
        api_key = @project.api_keys.find_or_create_by_name(api_key[:name])
        #add all non-removed and newly added key ids
        params[:project][:api_key_ids] = []
        params[:project][:api_key_ids] << api_key.id
      end
    end

    if @project.update_attributes(params[:project])
      flash[:notice] = "Project keys updated"
      redirect_to edit_project_path(@project)
    else
      flash[:alert] = "Project keys could not be updated"
      render '/projects/edit'
    end
  end
end
