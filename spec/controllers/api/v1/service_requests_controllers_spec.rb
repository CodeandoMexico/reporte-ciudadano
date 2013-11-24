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

      describe 'GET index' do
        let!(:service_requests) { create_list(:service_request, 3) }

        it 'returns a list of service requests in a span of 90 days or first 1000, whichever is smallest' do
          get :index, format: 'json'
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(service_requests.count)
        end

        it 'returns a list of service requests specified by ids' do
          ids = [service_requests[0].id, service_requests[1].id]
          get :index, format: 'json', service_request_id: ids.join(',')
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(2)
        end

        it 'returns a list of service requests specified by service code' do
          ids = [service_requests[0].service_id, service_requests[1].service_id]
          get :index, format: 'json', service_code: ids.join(',')
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(2)
        end

        it 'returns a list of service requests specified by start date' do
          create(:service_request, created_at: 5.days.ago)
          start_date = 3.days.ago.to_time.utc.iso8601
          get :index, format: 'json', start_date: start_date.to_s
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(3)
        end

        it 'returns a list of service requests specified by end date' do
          create(:service_request, created_at: 3.days.ago)
          end_date = 2.days.ago.to_time.utc.iso8601
          get :index, format: 'json', end_date: end_date.to_s
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(1)
        end

        it 'returns a list of service requests specified by status' do
          another_request = create(:service_request)
          another_request.update_attribute(:status, create(:status))
          get :index, format: 'json', status: service_requests.first.status.name
          body = JSON.parse(response.body)
          expect(body['service_requests'].count).to eq(3)
        end

      end

    end
  end
end
