FactoryGirl.define do
  factory :survey_answer do
    text "MyString"
    question nil
    score "9.99"
    user nil
    factory :survey_answer_binary do
      score 1
      user nil
      question nil
    end
  end
end
