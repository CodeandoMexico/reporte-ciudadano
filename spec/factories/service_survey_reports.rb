FactoryGirl.define do
  factory :service_survey_report do
    service_survey_id nil
    association :service_survey, factory: :survey_with_binary_question

    factory :valid_service_survey_report do
      before(:create) do |report|
        report.service_survey_id = FactoryGirl.create(:survey_with_binary_question_and_answers).id
      end
    end

    factory :valid_service_survey_report_100 do
      before(:create) do |report|
        report.service_survey_id = FactoryGirl.create(:survey_with_binary_rating_questions_and_answers).id
      end

    end

    factory :valid_service_survey_report_75 do
      before(:create) do |report|
        report.service_survey_id = FactoryGirl.create(:survey_with_rating_questions_and_answers).id
      end
    end

    factory :invalid_service_survey_report do
      service_survey_id nil
      association :service_survey, factory: :survey_with_binary_question
    end
  end

end