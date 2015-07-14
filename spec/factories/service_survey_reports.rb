FactoryGirl.define do
  factory :service_survey_report do
    service_survey_id nil
    association :service_survey, factory: :survey_with_binary_question


    before(:create) do |report|
      report.service_survey_id = FactoryGirl.create(:survey_with_binary_question_and_answers).id
    end

    factory :invalid_service_survey_report do
      service_survey_id nil
      association :service_survey, factory: :survey_with_binary_question
    end
  end

end