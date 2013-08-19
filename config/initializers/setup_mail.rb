ActionMailer::Base.smtp_settings = {
  :user_name => SENDGRID[:username],
  :password => SENDGRID[:password],
  :domain => SENDGRID[:domain],
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
