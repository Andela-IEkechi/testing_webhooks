CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',       # required
      :aws_access_key_id      => 'AKIAJ3XPAWJPN6KR2QPQ',       # required
      :aws_secret_access_key  => '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',       # required
      :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = 'conductorappsa'                     # required
    config.fog_public     = true                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else #dev and staging
    config.storage = :file
    # config.storage = :fog
    # config.fog_credentials = {
    #   :provider               => 'AWS',       # required
    #   :aws_access_key_id      => 'AKIAJ3XPAWJPN6KR2QPQ',       # required
    #   :aws_secret_access_key  => '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',       # required
    #   :region                 => 'us-east-1'  # optional, defaults to 'us-east-1'
    # }
    # config.fog_directory  = 'conductorappsadev'                     # required
    # config.fog_public     = true                                   # optional, defaults to true
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
    # #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil
  end
end
