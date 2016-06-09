class ApiIntegrationsController < ApplicationController
  skip_before_action :load_resource
  skip_before_action :verify_authenticity_token, only: [:git_hub]
  after_action :verify_authorized

  def git_hub
    GitPushNotificationService.new(params).make_into_comment
    render head :no_content
  end
end