class ServicesController < ApplicationController
  def load_service_fields
    @service = Service.find(params[:id]) 
    @service_fields = @service.service_fields
  end
end
