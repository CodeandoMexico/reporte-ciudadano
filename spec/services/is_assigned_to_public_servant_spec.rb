require 'spec_helper'
require_relative '../../app/services/services'

module Services
  describe 'service is assigned to public servant?' do
    it 'return true when the service is assigned to the public servant' do
      service = double 'Service', id: 'service-id'
      public_servant = double 'Public servant', services: [service]
      is_assigned = Services.is_assigned_to_public_servant?(service, public_servant)
      expect(is_assigned).to eq true
    end

    it 'return false when the service is assigned to the public servant' do
      service = double 'Service', id: 'service-id'
      other_service = double 'Service', id: 'other-service-id'
      public_servant = double 'Public servant', services: [service]
      is_assigned = Services.is_assigned_to_public_servant?(other_service, public_servant)
      expect(is_assigned).to eq false
    end
  end
end