CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJ3XPAWJPN6KR2QPQ',       # required
    :aws_secret_access_key  => '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',       # required
    :region                 => 'eu-east-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'conductorappsadev'                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #config.asset_host     = 'https://assets.example.com'            # optional, defaults to nil
end