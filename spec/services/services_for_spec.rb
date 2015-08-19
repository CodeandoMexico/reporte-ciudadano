require 'spec_helper'
require_relative '../../app/services/admins'

module Admins
  class TestService
    attr_accessor :id

    def initialize(attrs)
      @id = attrs[:id]
    end
  end

  describe 'services for' do
    it 'returns all active services when is super admin' do
      admin = double 'admin', is_service_admin?: false, is_super_admin?: true
      expect(Service).to receive(:active)
      services_for(admin)
    end

    it 'returns the managed services when is service admin' do
      service = TestService.new(id: 'my-service-id')
      admin = double 'admin', is_service_admin?: true, is_super_admin?: false, managed_services: [service]

      expect(Service).not_to receive(:all)
      expect(services_for(admin).count).to eq 1
    end

    def services_for(admin)
      Admins.services_for(admin)
    end
  end
end