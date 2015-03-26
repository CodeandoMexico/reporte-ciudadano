require 'spec_helper'

describe ServiceRequestsController, type: :controller do

  describe 'GET markers_for_gmap' do
    it 'returns a group of service_requests' do
      create_list(:service_request, 3)
      get :markers_for_gmap, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['service_requests'].count).to eq(3)
    end
  end

end
