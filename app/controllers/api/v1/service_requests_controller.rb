module Api
  module V1
    class ServiceRequestsController < Api::BaseController
      respond_to :json
      before_filter :authenticate_admin!

      def create
        respond_with current_admin.service_requests.create(params[:service_request])
      end

      def update_status
        @service_request = ServiceRequest.find(params[:service_request_id])
        @service_request.update_attribute :status, params[:status]
        respond_with @service_request
      end
    end
  end
end
