require 'spec_helper'
require_relative '../../app/services/services'

module Services
  describe 'service is assigned to cis?' do
    it 'return true when the service is assigned to the cis' do
      cis = { id: 'cis-id', label: 'cis - address'}
      service = double 'Service', id: 'service-id', cis: ['cis-id']
      is_assigned = Services.is_assigned_to_cis?(service, 'cis-id')
      expect(is_assigned).to eq true
    end

    it 'return false when the service is assigned to the cis' do
      cis = { id: 'cis-id', label: 'cis - address'}
      service = double 'Service', id: 'service-id', cis: []
      is_assigned = Services.is_assigned_to_cis?(service, 'cis-id')
      expect(is_assigned).to eq false
    end
  end
end