class Question < ActiveRecord::Base
  belongs_to :service_survey
  serialize :answers, Array
end
