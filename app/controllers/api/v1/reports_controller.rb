module Api
  module V1
    class ReportsController < Api::BaseController
      respond_to :json

      def create
        respond_with Report.create(params[:report])  
      end

      def update_status
        @report = Report.find(params[:id])
        @report.update_attribute :status, params[:status]
        respond_with @report
      end

    end
  end
end
