class ApiIntegrationsController < ApplicationController
  skip_before_action :load_resource
  skip_before_action :verify_authenticity_token, only: [:git_hub]
  after_action :verify_authorized

  def git_hub
    if verify_git_signature(request)
      GitPushNotificationService.new(params).make_into_comment
    end
    render head :no_content
  end

  def verify_git_signature(request)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GIT_HOOK_SECRET_TOKEN'], request.body.read)
    return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

end