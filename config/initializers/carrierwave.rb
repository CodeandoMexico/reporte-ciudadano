CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_KEY'],
    :aws_secret_access_key  => ENV['AWS_SECRET']
  }
  config.fog_directory  = ENV['S3_BUCKET']
  config.fog_public     = true
  config.root      = Rails.root.join('tmp')
  config.cache_dir = 'files'

  config.permissions = 0600

  config.storage(Rails.env.test? || Rails.env.development? ? :file : :fog)
  config.enable_processing = false if Rails.env.test?
end
