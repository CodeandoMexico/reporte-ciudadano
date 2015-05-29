FactoryGirl.define do
  factory :question do
    criterion "transparency"
    text "Question text"
    answer_type "binary"

    trait :binary do
      answer_type "binary"
      answers ["Sí", "No"]
    end

    trait :rating do
      answer_type "rating"
      answer_rating_range "good"
      answers ["Muy bueno", "Bueno", "Regular", "Malo", "Muy malo"]
      value 20.0
    end
  end
end
