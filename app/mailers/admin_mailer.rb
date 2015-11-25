class AdminMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"] || 'Urbem <no-responder@urbem.org>'

  def send_service_admin_account(admin:)
    @admin = admin
    @app_name = ENV["APP_NAME"]
    mail to: admin.email, subject: I18n.t('mailer.subject.send_account_invitation', app_name: @app_name)
  end

  def send_public_servant_account(admin:)
    @admin = admin
    @app_name = ENV["APP_NAME"]
    mail to: admin.email, subject: I18n.t('mailer.subject.send_account_invitation', app_name: @app_name)
  end

  def notify_new_request(admin:, service_request:)
    @user = service_request.requester
    @admin = admin
    @service = service_request.service
    @service_request = service_request
    mail to: @admin.email, subject: I18n.t('mailer.subject.notify_new_request')
  end

  def send_public_servant_update_request(admin:)
    @admin = admin
    mail to: admin.email, subject: I18n.t('mailer.subject.send_request_new')
  end
end