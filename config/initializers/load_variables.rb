unless Rails.env.production?
  env = YAML.load_file("#{Rails.root}/config/env_variables.yml")[Rails.env]
  if env
    TWITTER_KEY       = env['twitter']['key']
    TWITTER_SECRET    = env['twitter']['secret']
    FACEBOOK_KEY      = env['facebook']['key']
    FACEBOOK_SECRET   = env['facebook']['secret']
    GOOGLE_KEY        = env['google_maps']['key']
  end
end

TWITTER_KEY       ||= ENV['TWITTER_KEY']
TWITTER_SECRET    ||= ENV['TWITTER_SECRET']
FACEBOOK_KEY      ||= ENV['FACEBOOK_KEY']
FACEBOOK_SECRET   ||= ENV['FACEBOOK_SECRET']
GOOGLE_KEY        ||= ENV['GOOGLE_KEY']

