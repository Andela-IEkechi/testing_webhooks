class ApiIntegrationsController < ApplicationController
  skip_before_action :load_resource
  skip_before_action :verify_authenticity_token

  def git_hub
    GitPushNotificationService.new(params).make_into_comment
  end
end