class ServiceSurveyReport < ActiveRecord::Base
  belongs_to :service_survey

  before_create :get_results_for_survey

  def get_results_for_survey(id)
    positive_overall_perception = self.report(id)[:survey_results][:positive]
    negative_overall_perception = self.report(id)[:survey_results][:negative]

  end

  private

  def self.report(id)
     survey_results = effectiveness_survey(id)
     {}.merge(survey_results)
  end

  def self.people_who_participated_in_survey(id)

  end

  def self.effectiveness_survey(id)
    {:survey => {:positive =>"#{overall_effectiveness(id)}",
                 :negative => "#{ 100 - overall_effectiveness(id)}"},
     :title => ServiceSurvey.find(id).title
    }
  end

  def self.overall_effectiveness(id)
    rating_answers(id).map(&:score).sum.to_i
  end

  def self.rating_answers(id)
    ServiceSurvey.find(id).rating_answers
  end

end
