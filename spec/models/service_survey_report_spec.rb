require 'spec_helper'

describe ServiceSurveyReport do
  context 'factories' do
    it 'has a valid factories' do
      expect(create(:valid_service_survey_report)).to be_valid
      expect(create(:valid_service_survey_report_100)).to be_valid
      expect(create(:valid_service_survey_report_75)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_service_survey_report)).to_not be_valid
    end
  end

  context 'attributes' do
    it { should respond_to :service_survey_id }
    it { should respond_to :positive_overall_perception }
    it { should respond_to :negative_overall_perception }
    it { should respond_to :people_who_participated }
    it { should respond_to :areas_results }
  end

  context 'associations' do
    it { should belong_to :service_survey }
  end

  context 'report with 100% overall results and only answers in transparency' do
    let(:service_survey_report) { create(:valid_service_survey_report_100) }

    it 'is report with 100% #positive_overall_perception' do
      service_survey_report.reload
      expect(service_survey_report.positive_overall_perception).to eq 100.0
    end
    it 'is  a report with 0% #negative_overall_perception' do
      service_survey_report.reload
      expect(service_survey_report.negative_overall_perception).to eq 0.0
    end
    it 'is a report with 100% transparency in  #areas_results[:transparency]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:transparency]).to eq 100.0
    end
    it 'is a report with 0% in #areas_results[:performance]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:performance]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:quality_service]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:quality_service]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:accessibility]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:accessibility]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:infrastructure]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:infrastructure]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:public_servant]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:public_servant]).to eq 0.0
    end
  end
  context 'report with 75% overall results and only answers in transparency' do
    let(:service_survey_report) { create(:valid_service_survey_report_75) }

    it 'is report with 175% #positive_overall_perception' do
      service_survey_report.reload
      expect(service_survey_report.positive_overall_perception).to eq 75.0
    end
    it 'is  a report with 25% #negative_overall_perception' do
      service_survey_report.reload
      expect(service_survey_report.negative_overall_perception).to eq 25.0
    end
    it 'is a report with 75% transparency in  #areas_results[:transparency]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:transparency]).to eq 75.0
    end
    it 'is a report with 0% in #areas_results[:performance]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:performance]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:quality_service]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:quality_service]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:accessibility]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:accessibility]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:infrastructure]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:infrastructure]).to eq 0.0
    end
    it 'is a report with 0% in #areas_results[:public_servant]' do
      service_survey_report.reload
      expect(service_survey_report.areas_results[:public_servant]).to eq 0.0
    end
  end
end
