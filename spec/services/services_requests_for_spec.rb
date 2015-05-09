require 'spec_helper'
require_relative '../../app/services/admins'

module ServiceAdmins
  class TestAdmin
    attr_accessor :managed_services, :is_service_admin, :is_public_servant

    def initialize(attrs)
      @managed_services = attrs[:managed_services]
      @is_service_admin = attrs[:is_service_admin]
      @is_public_servant = attrs[:is_public_servant]
    end

    def is_super_admin?
      !(is_service_admin || is_public_servant)
    end

    def is_service_admin?
      is_service_admin
    end
  end

  class TestService
    attr_accessor :service_requests

    def initialize(attrs)
      @service_requests = attrs[:service_requests]
    end
  end

  class TestServiceRequest
    attr_accessor :service_id

    def initialize(attrs)
      @service_id = attrs[:service_id]
    end
  end

  describe 'services requests for' do
    attr_reader :service_requests

    before do
      @service_requests = [TestServiceRequest.new(service_id: 'service-id'), TestServiceRequest.new(service_id: 'other-service-id')]
    end

    it 'returns the managed services when is super admin' do
      admin = TestAdmin.new(is_public_servant: false, is_service_admin: false)
      expect(ServiceRequest).to receive(:filter_by_search).with({})
      service_requests_for(admin, {})
    end

    it 'returns the managed services when is service admin' do
      service = TestService.new(service_requests: service_requests.first, id: 'service-id')
      admin = TestAdmin.new(managed_services: [service], is_service_admin: true)

      expect(ServiceRequest).not_to receive(:filter_by_search).with({})
      expect(service_requests_for(admin, {}).count).to eq 1
    end

    def service_requests_for(admin, params)
      Admins.service_requests_for(admin, params)
    end
  end
end