Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, :scope => 'email'
end

OmniAuth.config.on_failure = SessionsHelper.instance_methods(:failure)

