class MessagesController < ApplicationController
  def index
    service_request = ServiceRequest.find params[:service_request_id]
    @messages = service_request.service.messages.with_status(params[:status_id])
    respond_to do |format|
      format.js
    end
  end
end
