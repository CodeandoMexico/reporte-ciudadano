FactoryGirl.define do
  factory :service_survey do
    title "A survey title"
    phase "start"
    open true

    factory :survey_with_binary_question do
      after(:create) do |survey, evaluator|
        create :question, :binary, value: 100.0, service_survey: survey
        survey.reload
      end
    end
  end
end
