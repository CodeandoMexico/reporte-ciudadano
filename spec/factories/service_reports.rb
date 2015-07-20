FactoryGirl.define do
  factory :service_report do
    positive_overall_perception "9.99"
negative_overall_perception "9.99"
respondents_count 1
overall_areas "MyText"
service nil
  end

end
