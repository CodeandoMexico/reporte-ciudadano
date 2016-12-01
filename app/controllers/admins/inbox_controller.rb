class Admins::InboxController < Admins::AdminController
  layout 'admins'

  def index
    params[:q] ||= {}
    @q = ServiceRequest.ransack(params[:q])
    @service_requests = @q.result.page(params[:page]).per(10)
  end

  def surveys
    params[:q] ||= {}
    @q = ServiceSurvey.ransack(params[:q])
    @surveys = @q.result.page(params[:page]).per(10)
  end
end
