CarrierWave.configure do |config|
  config.fog_directory      = Rails.root.join('storage')
  config.permissions = 0600
  config.storage(:file)
  config.enable_processing = false if Rails.env.test?
end
