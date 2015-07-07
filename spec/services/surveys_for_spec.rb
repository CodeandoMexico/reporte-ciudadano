require 'spec_helper'
require_relative '../../app/services/admins'

module Admins
  class TestServiceSurvey
    attr_accessor :admin_id

    def initialize(attrs)
      @admin_id = attrs[:admin_id]
    end
  end

  describe 'surveys for' do
    attr_reader :service_surveys

    before do
      @service_surveys = [TestServiceSurvey.new(admin_id: 'admin-id'), TestServiceSurvey.new(admin_id: 'other-admin-id')]
    end

    it 'returns the managed services when is super admin' do
      admin = double 'admin', is_super_admin?: true
      expect(ServiceSurvey).to receive(:all)
      surveys_for(admin)
    end

    it 'returns the managed surveys when is service admin' do
      service_surveys = [TestServiceSurvey.new(admin_id: 'admin-id'), TestServiceSurvey.new(admin_id: 'admin-id')]
      admin = double 'admin', is_service_admin?: true, id: 'admin-id', is_super_admin?: false, service_surveys: service_surveys
      expect(ServiceSurvey).not_to receive(:all)
      expect(surveys_for(admin).count).to eq 2
    end

    def surveys_for(admin)
      Admins.surveys_for(admin)
    end
  end
end