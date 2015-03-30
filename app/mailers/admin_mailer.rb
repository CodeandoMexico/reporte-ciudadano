class AdminMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"]

  def send_account_invitation(admin:, password:)
    @password = password
    @admin = admin
    @app_name = ENV["APP_NAME"]
    mail to: admin.email, subject: I18n.t('mailer.subject.send_account_invitation', app_name: @app_name)
  end
end