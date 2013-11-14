require 'spec_helper'

module Api
  module V1
    describe ServiceRequestsController do

      describe 'GET show' do
        let(:service_request) { create(:service_request)}

        context 'when the service request is found' do
          before { get :show, id: service_request.id, format: 'json' }
          it { should respond_with 200 }
        end

        context 'when the service request is not found' do
          before { get :show, id: 12, format: 'json'}

          it { should respond_with 404 }

          it 'returns 404 as the value for the error key in the response' do
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq(404)
          end

          it 'returns a description for the error' do
            json_response = JSON.parse(response.body)
            expect(json_response['description']).to_not be_nil
          end

        end
      end

    end
  end
end
