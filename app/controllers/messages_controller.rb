class MessagesController < ApplicationController
  def index
    report = Report.find params[:report_id]
    @messages = report.category.messages.with_status(params[:status_id])
    respond_to do |format|
      format.js
    end
  end
end
