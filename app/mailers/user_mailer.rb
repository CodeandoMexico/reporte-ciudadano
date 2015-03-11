class UserMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || 'Urbem <no-responder@urbem.org>'

  def notify_service_request_status_change(service_request_id, previous_status_id)
    @service_request = ServiceRequest.find(service_request_id)
    @user = @service_request.requester
    @previous_status = Status.find(previous_status_id)
    mail(subject: I18n.t('mailer.subject.status_change_notification'), to: @user.email)
  end
end

