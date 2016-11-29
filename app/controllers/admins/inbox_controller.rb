class Admins::InboxController < ApplicationController
  layout 'admins'

  def index
    params[:q] ||= {}
    @q = ServiceRequest.ransack(params[:q])
    @service_requests = @q.result.page(params[:page]).per(10)
  end
end
