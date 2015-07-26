require 'spec_helper'

describe ServiceRequest do
  context 'validations' do
    it 'has a valid factory' do
      expect(build(:service_request)).to be_valid
    end
    it { should validate_presence_of(:service_id) }
    it { should validate_presence_of(:description) }
  end
  context 'attributes' do
    it { should respond_to :anonymous }
    it { should respond_to :description }
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

  context 'callbacks' do
    it 'should assign a default status before validation on create' do
      default_status = create(:default_status)
      service_request = create(:service_request)
      expect(service_request.status).to eq(default_status)
    end

    describe '.send_notification_for_status_update' do
      let!(:service_request) { FactoryGirl.create(:service_request) }

      it 'sends an email when a service request status is updated and was requested by a user' do
        expect do
          service_request.update_attributes(status_id: FactoryGirl.create(:status).id)
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end

      it 'does not send an email when the service was created by an admin' do
        admin = create(:admin)
        admin_request = create(:service_request, requester: admin)
        expect do
          admin_request.update_attributes(status_id: FactoryGirl.create(:status).id)
        end.to_not change{ ActionMailer::Base.deliveries.size }
      end

      it 'does not send an email when any other attribute was updated' do
        expect do
          service_request.update_attributes(address: 'Nueva direccion')
        end.to_not change{ ActionMailer::Base.deliveries.size }
      end

    end
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
      categorized_service_requests = ServiceRequest.on_service(service_requests.first.service_id.to_s)
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
      expect(service_request.service?).to be
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

    describe '.requested_by_user?' do
      it 'returns true when the service request was made by a user' do
        expect(service_request.requested_by_user?).to be true
      end

      it 'returns false when the service request was not made by a user' do
        admin = FactoryGirl.create(:admin)
        admin_request = FactoryGirl.create(:service_request, requester: admin)
        expect(admin_request.requested_by_user?).to be false

      end
    end

  end
end
