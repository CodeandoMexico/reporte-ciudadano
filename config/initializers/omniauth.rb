#Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, :scope => 'email'
  #provider :twitter, TWITTER_KEY, TWITTER_SECRET
#end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email'
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

#OmniAuth.config.on_failure = SessionsHelper.instance_methods(:failure)
