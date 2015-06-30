class UserMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || 'Urbem <no-responder@urbem.org>'

  def notify_service_request_status_change(service_request_id, previous_status_id)
    @service_request = ServiceRequest.find(service_request_id)
    @user = @service_request.requester
    @previous_status = Status.find(previous_status_id)
    mail(subject: I18n.t('mailer.subject.status_change_notification'), to: @user.email)
  end

  def confirm_service_survey_answer(service_survey, user)
    @user = user
    @service_survey = service_survey
    mail(subject: I18n.t('mailer.subject.confirm_service_survey_answer'), to: @user.email)
  end
end

