require 'spec_helper'

describe ServiceRequest do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:service_request)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_service_request)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :anonymous }
    it { should respond_to :description }
    it { should respond_to :lat }
    it { should respond_to :lng }
    it { should respond_to :service_fields }
    it { should respond_to :address }
    it { should respond_to :message }
  end
  context 'associations' do
    it { should belong_to :service }
    it { should belong_to :requester }
    it { should belong_to :status }
    it { should have_many :comments }
  end
  context 'scopes' do
    let(:service_requests) {[]}

    before :each do
      3.times { |n| service_requests << create(:service_request, created_at: n.days.ago)}
    end

    it '.default scope orders the service_requests by created date descending' do
      expect(ServiceRequest.all).to eq(service_requests)
    end

    it '.on_start_date returns service_requests created from the desired dates onwards' do
      expect(ServiceRequest.on_start_date(2.days.ago)).to eq([service_requests[0], service_requests[1]])
    end

    it '.on_finish_date returns service_requests created before the desired date' do
      expect(ServiceRequest.on_finish_date(1.days.ago)).to eq([service_requests[1], service_requests[2]])
    end

    it '.on_service returns service_requests related to certain service' do
      categorized_service_requests = ServiceRequest.on_service(service_requests.first.service)
      expect(categorized_service_requests).to eq([service_requests.first])
    end

    it '.find_by_ids returns service_requests with the ids' do
      service_requests_by_ids = ServiceRequest.find_by_ids(service_requests.map(&:id).join(','))
      expect(service_requests_by_ids).to eq(service_requests)
    end
  end

  context :methods do
    let(:service_request) { create(:service_request) }

    it '#service? tells me if my service_request has a service' do
      expect(service_request.service?).to be_true
    end

    it '#service_requester returns a hash with the avatar_url and name from the service_requester' do
      service_requester = {avatar_url: service_request.requester.avatar_url, name: service_request.requester.name}
      expect(service_request.service_requester).to eq(service_requester)
    end

    it '#service_requester returns a hash with an anonymous user when no user detected' do
      anonymous_service_request = create(:service_request, anonymous: true)
      service_requester = {avatar_url: 'http://www.gravatar.com/avatar/foo', name: 'Anónimo'}
      expect(anonymous_service_request.service_requester).to eq(service_requester)
    end

    it '#date returns the service_request created date with date format' do
      expect(service_request.date).to eq(service_request.created_at.to_date)
    end

    it '.chart_data returns service_requests grouped by service' do
      data = ServiceRequest.chart_data
      expect(data.to_a.count).to eq(Service.count)
    end

  end
end
