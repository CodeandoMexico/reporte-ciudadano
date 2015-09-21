CarrierWave.configure do |config|
=begin
  unless Rails.env.test?
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_KEY'],
      :aws_secret_access_key  => ENV['AWS_SECRET']
    }
    config.fog_directory  = ENV['S3_BUCKET']
  end
=end
  config.fog_public     = true
  config.root      = Rails.root.join('storage')
  # config.cache_dir = "tmp"
  config.permissions = 0600
  config.storage(:file)
  config.enable_processing = false if Rails.env.test?
end
