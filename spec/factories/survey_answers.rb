FactoryGirl.define do
  factory :survey_answer do
    text "MyString"
    question nil
    score "9.99"
    association :user, factory: :user
  end
end
