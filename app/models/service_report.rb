class ServiceReport < ActiveRecord::Base

  def self.report(id)
     survey_results = effectiveness_survey(id)
     {}.merge(survey_results)
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
