require 'spec_helper'
require_relative '../../app/services/evaluations'
require_relative '../../app/services/services'

module Evaluations
  class TestService
    attr_accessor :cis, :admins, :service_surveys, :last_survey_reports, :id

    def initialize(attrs)
      @cis = attrs[:cis] || []
      @admins = attrs[:admins] || []
      @service_surveys = attrs[:service_surveys] || []
      @last_survey_reports = attrs[:last_survey_reports] || []
      @id = attrs[:id]
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

  class TestReport
    attr_accessor :areas_results, :positive_overall_perception

    def initialize(attrs)
      @areas_results = attrs[:areas_results]
      @positive_overall_perception = attrs[:positive_overall_perception]
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

    describe 'services overall evaluation' do
      [ :transparency, :performance, :quality_of_service, :accesibility, :infrastructure ].each do |criterion|
        it "returns the evaluation for a service in a given criterion: #{criterion}" do
          survey_reports = [TestReport.new(areas_results: areas_results(60.0)), TestReport.new(areas_results: areas_results(50.0))]
          services = [TestService.new(cis: ["1"], last_survey_reports: survey_reports)]
          first_cis = first_cis_with_results(cis, services: services)
          expect(first_cis.services.first.overall_evaluation_for(criterion)).to eq 55.0
        end

        it "returns the evaluation for a service in a given criterion: #{criterion}" do
          survey_reports = [TestReport.new(areas_results: areas_results(0.0)), TestReport.new(areas_results: areas_results(0.0))]
          services = [TestService.new(cis: ["1"], last_survey_reports: survey_reports)]
          first_cis = first_cis_with_results(cis, services: services)
          expect(first_cis.services.first.overall_evaluation_for(criterion)).to eq 0.0
        end

        it "returns 0.0 if no reports are given: #{criterion}" do
          survey_reports = []
          services = [TestService.new(cis: ["1"], last_survey_reports: survey_reports)]
          first_cis = first_cis_with_results(cis, services: services)
          expect(first_cis.services.first.overall_evaluation_for(criterion)).to eq 0.0
        end
      end
    end

    it 'returns the best and worst evaluated service' do
      best_survey_reports = [TestReport.new(positive_overall_perception: 90.0), TestReport.new(positive_overall_perception: 80.0)]
      worst_survey_reports = [TestReport.new(positive_overall_perception: 20.0), TestReport.new(positive_overall_perception: 10.0)]
      services = [TestService.new(id: 'best-service', cis: ["1"], last_survey_reports: best_survey_reports), TestService.new(id: 'worst-service', cis: ["1"], last_survey_reports: worst_survey_reports)]
      first_cis = first_cis_with_results(cis, services: services)

      expect(first_cis.best_evaluated_service.id).to eq 'best-service'
      expect(first_cis.worst_evaluated_service.id).to eq 'worst-service'
      expect(first_cis.best_evaluated_service.positive_overall_perception).to eq 85.0
      expect(first_cis.worst_evaluated_service.positive_overall_perception).to eq 15.0
    end

    def areas_results(percentage)
      {
        transparency: percentage,
        performance: percentage,
        quality_of_service: percentage,
        accesibility: percentage,
        infrastructure: percentage
      }
    end

    def cis_with_results(cis, services: [])
      Evaluations.cis_with_results(cis, services)
    end

    def first_cis_with_results(cis, services: [])
      cis_with_results(cis, services: services).first
    end
  end
end