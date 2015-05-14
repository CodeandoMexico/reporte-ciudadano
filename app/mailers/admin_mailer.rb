class AdminMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || 'Urbem <no-responder@urbem.org>'

  def send_service_admin_account(admin:, password:)
    @password = password
    @admin = admin
    @app_name = ENV["APP_NAME"]
    mail to: admin.email, subject: I18n.t('mailer.subject.send_account_invitation', app_name: @app_name)
  end

  def send_public_servant_account(admin:, password:)
    @password = password
    @admin = admin
    @app_name = ENV["APP_NAME"]
    mail to: admin.email, subject: I18n.t('mailer.subject.send_account_invitation', app_name: @app_name)
  end
end