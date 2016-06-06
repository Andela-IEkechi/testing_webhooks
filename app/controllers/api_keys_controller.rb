class ApiKeysController < ApplicationController
  respond_to :json

  def index
    render json: @api_keys
  end

  def show
    render json: @api_key
  end

  def create
    if @api_key.valid? && @api_key.save
      render json: @api_key
    else
      render json: {errors: @api_key.errors.full_messages}, status: 422
    end
  end

  def destroy
    if @api_key.destroy
      render json: @api_key
    else
      render json: {errors: @api_key.errors.full_messages}, status: 422
    end
  end

  private

  def api_key_params
    params.require(:api_key).permit(
        :id, :name, :access_key, :_destroy
    )
  end

  def load_resource
    @project = Project.friendly.find(params[:project_id])
    @resource_scope = policy_scope(@project.api_keys)
    super
  end
end