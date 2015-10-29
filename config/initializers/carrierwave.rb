CarrierWave.configure do |config|
  config.fog_directory      = Rails.root.join('public')
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage(:file)
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
  config.enable_processing = false if Rails.env.test?
end