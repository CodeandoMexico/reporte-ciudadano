class ServicesController < ApplicationController
  def load_service_fields
     begin
      @service = Service.find(params[:id]) 
      @service_fields = @service.service_fields
      rescue ActiveRecord::RecordNotFound
    end
  end
end
