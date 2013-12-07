class Admins::MessagesController < Admins::AdminController
  def index
    service = Service.find params[:service_id]
    @messages = service.messages.with_status(params[:status_id])
    respond_to do |format|
      format.js
    end
  end
end
