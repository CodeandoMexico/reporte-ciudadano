FactoryGirl.define do
  factory :survey_answer do
    text "MyString"
    question nil
    score "9.99"
    user nil
    factory :survey_answer_binary do
      score nil
      user nil
      question nil
    end
    factory :survey_answer_rating do
      score nil
      user nil
      question nil
    end

    factory :survey_answer_binary_yes, traits:[:yes_answer]
    factory :survey_answer_binary_no, traits:[:no_answer]
    factory :survey_answer_rating_100, traits:[:hundred_percent]
    factory :survey_answer_rating_75, traits: [:seventy_five_percent]
    factory :survey_answer_rating_50, traits:[:fifty_percent]
    factory :survey_answer_rating_25, traits: [:twenty_five_percent]
    factory :survey_answer_rating_0, traits: [:zero_percent]

    trait :hundred_percent do
      score 1
    end
    trait :seventy_five_percent do
      score 0.75
    end
    trait :fifty_percent do
      score 0.5
    end
    trait :twenty_five_percent do
      score 0.25
    end
    trait :zero_percent do
      score 0
    end
    trait :no_answer do
      score 0
    end
    trait :yes_answer do
      score 1
    end

  end
end
