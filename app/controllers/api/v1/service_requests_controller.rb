module Api
  module V1
    class ServiceRequestsController < Api::BaseController
      respond_to :json

      def show
        @service_request = ServiceRequest.find(params[:id])
        respond_with @service_request
      rescue ActiveRecord::RecordNotFound
        @response = {error: 404, description: "Service request not found"}
        respond_with @response, status: :not_found
      end

    end
  end
end
