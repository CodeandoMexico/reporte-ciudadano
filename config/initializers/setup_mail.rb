ActionMailer::Base.smtp_settings = {
  :user_name => SENDGRID_CREDENTIAL[:username],
  :password => SENDGRID_CREDENTIAL[:password],
  :domain => SENDGRID_CREDENTIAL[:domain],
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
