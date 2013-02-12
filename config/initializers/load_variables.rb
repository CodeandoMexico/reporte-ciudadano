env = YAML.load_file("#{Rails.root}/config/env_variables.yml")[Rails.env]
TWITTER_KEY = ENV['TWITTER_KEY'] || env['twitter']['key']
TWITTER_SECRET = ENV['TWITTER_SECRET'] || env['twitter']['secret']

FACEBOOK_KEY = ENV['FACEBOOK_KEY'] || env['facebook']['key'] 
FACEBOOK_SECRET = ENV['FACEBOOK_SECRET'] || env['facebook']['secret']

GOOGLE_KEY = ENV['GOOGLE_KEY'] || env['google_maps']['key']

if Rails.env.production? 
  AWS_KEY = ENV['AWS_KEY'] || env['aws']['key'] 
  AWS_SECRET = ENV['AWS_SECRET'] || env['aws']['secret'] 
end

