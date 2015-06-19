class ServiceSurveyReport < ActiveRecord::Base
  belongs_to :service_survey
  before_create :get_results_for_survey

  def get_results_for_survey
    self.positive_overall_perception = report(self.service_survey_id)[:survey][:positive]
    self.negative_overall_perception = report(self.service_survey_id)[:survey][:negative]
    self.people_who_participated = report(self.service_survey_id)[:people_count]
  end

  def report(service_survey_id)
     survey_results = effectiveness_survey(service_survey_id)
     {}.merge(survey_results)
  end

  def effectiveness_survey(service_survey_id)
    {:survey => {:positive =>"#{overall_effectiveness(service_survey_id)}",
                 :negative => "#{ 100 - overall_effectiveness(service_survey_id)}"},
     :title => ServiceSurvey.find(service_survey_id).title,
     :people_count => get_service_survey(service_survey_id).answers.select(:user_id).distinct.count
    }
  end

  def overall_effectiveness(service_survey_id)
    rating_answers(service_survey_id).map(&:score).sum.to_i
  end

  def rating_answers(service_survey_id)
    get_service_survey(service_survey_id).rating_answers
  end

  def get_service_survey(service_survey_id)
    ServiceSurvey.find(service_survey_id)
  end

end