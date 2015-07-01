require 'spec_helper'
require_relative '../../app/services/evaluations'
require_relative '../../app/services/services'

module Evaluations
  class TestService
    attr_accessor :cis, :admins, :service_surveys

    def initialize(attrs)
      @cis = attrs[:cis] || []
      @admins = attrs[:admins] || []
      @service_surveys = attrs[:service_surveys] || []
    end
  end

  class TestAdmin
    attr_accessor :id

    def initialize(attrs)
      @id = attrs[:id]
    end
  end

  class TestAnswer
    attr_accessor :user_id

    def initialize(attrs)
      @user_id = attrs[:user_id]
    end
  end

  describe 'cis with results' do
    attr_reader :cis

    before do
      @cis = [
        { id: 1, name: "Centro 1" },
        { id: 2, name: "Centro 2" }
      ]
    end

    it 'should return an array' do
      expect(cis_with_results(cis).size).to eq 2
    end

    it 'should respond to name' do
      first_cis = first_cis_with_results(cis)
      expect(first_cis.name).to eq "Centro 1"
    end

    describe 'evaluated services count' do
      example do
        services = [TestService.new(cis: ["1"]), TestService.new(cis: ["1", "2"])]
        first_cis = first_cis_with_results(cis, services: services)
        expect(first_cis.evaluated_services_count).to eq 2
      end

      example do
        services = [TestService.new(cis: ["1"]), TestService.new(cis: ["1", "3"])]
        last_cis = cis_with_results(cis, services: services).last
        expect(last_cis.evaluated_services_count).to eq 0
      end
    end

    describe 'evaluated public servants' do
      example do
        admin = TestAdmin.new(id: 'admin-id')
        services = [TestService.new(cis: ["1"], admins: [admin]), TestService.new(cis: ["1", "2"], admins: [admin])]
        first_cis = first_cis_with_results(cis, services: services)
        expect(first_cis.evaluated_public_servants_count).to eq 1
      end

      example do
        admin = TestAdmin.new(id: 'admin-id')
        services = [TestService.new(cis: ["1"], admins: [admin, TestAdmin.new(id: 'other-admin')]), TestService.new(cis: ["1", "2"], admins: [admin])]
        first_cis = first_cis_with_results(cis, services: services)
        expect(first_cis.evaluated_public_servants_count).to eq 2
      end

      example do
        admin = TestAdmin.new(id: 'admin-id')
        services = [TestService.new(cis: ["1"], admins: [admin, TestAdmin.new(id: 'other-admin')]), TestService.new(cis: ["1", "2"], admins: [])]
        first_cis = first_cis_with_results(cis, services: services)
        expect(first_cis.evaluated_public_servants_count).to eq 2
      end
    end

    describe 'surveys participants count' do
      example do
        answer = TestAnswer.new(user_id: 'user-id')
        surveys = double 'survey', answers: [answer]
        services = [TestService.new(cis: ["1"], service_surveys: [surveys])]
        first_cis = first_cis_with_results(cis, services: services)
        expect(first_cis.survey_participants_count).to eq 1
      end
    end

    def cis_with_results(cis, services: [])
      Evaluations.cis_with_results(cis, services)
    end

    def first_cis_with_results(cis, services: [])
      cis_with_results(cis, services: services).first
    end
  end
end