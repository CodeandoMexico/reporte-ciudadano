FactoryGirl.define do
  factory :service_survey do
    title "A survey title"
    phase "start"
    open true
    association :admin, factory: :admin

    factory :survey_with_binary_question do
      after(:create) do |survey, evaluator|
        create :question, :binary, value: 100.0, service_survey: survey
        survey.reload
      end
      factory :survey_with_binary_question_and_answers do
        transient do
          answers_count 5
          questions_count 1
        end
        after(:create) do |survey, evaluator|
          create_list(:question, evaluator.questions_count, :binary, service_survey: survey).each do |q|
            create_list(:survey_answer_binary,  evaluator.answers_count, question: q,
                        user: FactoryGirl.create(:user))
          end
        end
      end
    end
  end
end
