require 'spec_helper'

describe ServiceSurveyReport do
  context 'factories' do
    it 'has a valid factory' do
      expect(create(:service_survey_report)).to be_valid
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

end