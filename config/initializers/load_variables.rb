env = YAML.load_file("#{Rails.root}/config/env_variables.yml")[Rails.env]
TWITTER_KEY = ENV['TWITTER_KEY'] || env['twitter']['key']
TWITTER_SECRET = ENV['TWITTER_SECRET'] || env['twitter']['secret']

FACEBOOK_KEY = ENV['FACEBOOK_KEY'] || env['facebook']['key'] 
FACEBOOK_SECRET = ENV['FACEBOOK_KEY'] || env['facebook']['secret']  
