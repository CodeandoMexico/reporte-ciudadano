# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :logo do
    sequence(:title) { |n| "title ##{n}"}
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'features', 'images', 'avatar.png')) }
  end
end
