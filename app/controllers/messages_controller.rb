class MessagesController < ApplicationController
  def index
    report = Report.find params[:report_id]
    @messages = report.category.messages.with_status(params[:state])
    respond_to do |format|
      format.js
    end
  end
end
