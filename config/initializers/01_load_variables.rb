unless Rails.env.production?
  env = YAML.load_file("#{Rails.root}/config/env_variables.yml")[Rails.env]
  if env
    TWITTER_KEY       = env['twitter']['key']
    TWITTER_SECRET    = env['twitter']['secret']
    TWITTER_OAUTH_TOKEN = env['twitter']['oauth_token']
    TWITTER_OAUTH_TOKEN_SECRET = env['twitter']['oauth_token_secret']
    FACEBOOK_KEY      = env['facebook']['key']
    FACEBOOK_SECRET   = env['facebook']['secret']
    GOOGLE_KEY        = env['google_maps']['key']
  end
end

TWITTER_KEY       ||= ENV['TWITTER_KEY']
TWITTER_SECRET    ||= ENV['TWITTER_SECRET']
TWITTER_OAUTH_TOKEN ||= ENV['TWITTER_OAUTH_TOKEN']
TWITTER_OAUTH_TOKEN_SECRET ||= ENV['TWITTER_OAUTH_TOKEN_SECRET']
FACEBOOK_KEY      ||= ENV['FACEBOOK_KEY']
FACEBOOK_SECRET   ||= ENV['FACEBOOK_SECRET']
GOOGLE_KEY        ||= ENV['GOOGLE_KEY']

SENDGRID ||= {
  username: ENV['SENGRID_USERNAME'],
  password: ENV['SENGRID_PASSWORD'],
  domain: ENV['SENGRID_DOMAIN']
}
