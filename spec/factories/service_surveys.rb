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
          questions_count 5
        end
        after(:create) do |survey, evaluator|
          create_list(:question, evaluator.questions_count, :binary, service_survey: survey).each do |q|
            create_list(:survey_answer_binary_yes,  evaluator.answers_count, question: q,
                        user: FactoryGirl.create(:user))
          end
        end
      end
    end

    #Las pruebas de las encuestas tienen como base 10 preguntas
    #pues los valores de las respuestas
    # están ajustados a 10 preguntas.
    factory :survey_with_binary_rating_questions_and_answers do
      transient do
        answers_count 10
        questions_count 10
      end
      after(:create) do |survey, evaluator|

        users = create_list(:user, evaluator.answers_count)

        create_list(:question, evaluator.questions_count/2, :binary, service_survey: survey,
                    value: 100/evaluator.questions_count).each do |q|
          evaluator.answers_count.times do |i|
            create(:survey_answer_binary_yes, question: q,
                   user: users[i] )
          end
        end
        create_list(:question, evaluator.questions_count/2, :rating, service_survey: survey,
                    value: 100/evaluator.questions_count).each do |q|
          evaluator.answers_count.times do |i|
            create(:survey_answer_rating_100, question: q,
                   user: users[i]  )
          end
        end
      end
    end

    #Las pruebas de las encuestas tienen como base 10 preguntas
    #pues los valores de las respuestas
    # están ajustados a 10 preguntas.

    factory :survey_with_rating_questions_and_answers do
      transient do
        answers_count 10
        questions_count 10
      end
      after(:create) do |survey, evaluator|

        users = create_list(:user, evaluator.answers_count)

        create_list(:question, evaluator.questions_count, :rating, service_survey: survey,
                    value: 100/evaluator.questions_count).each do |q|
          evaluator.answers_count.times do |i|
            create(:survey_answer_rating_75, question: q,
                   user: users[i]  )
          end
        end
      end
    end
  end
end
