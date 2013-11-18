module Api
  module V1
    class ServiceRequestsController < Api::BaseController
      respond_to :json
      before_filter :set_date_range_in_params, only: :index

      def index
        @service_requests = ServiceRequest.filter_by_search_311(params).limit(1000)
        respond_with @service_requests
      end

      def show
        @service_request = ServiceRequest.find(params[:id])
        respond_with @service_request
      rescue ActiveRecord::RecordNotFound
        @response = {error: 404, description: "Service request not found"}
        respond_with @response, status: :not_found
      end

      private

      def set_date_range_in_params
        if params[:start_date].blank? || older_than_90_days(params[:start_date])
          params[:start_date] = Date.today.beginning_of_day - 90.days
        end

        if params[:end_date].blank? || older_than_90_days(params[:end_date])
          params[:end_date] = Date.today.end_of_day
        end
      end

      def older_than_90_days(date)
        parsed_date = Date.parse date
        parsed_date < (Date.today - 90.days)
      end

    end
  end
end
