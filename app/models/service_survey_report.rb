class ServiceSurveyReport < ActiveRecord::Base
  belongs_to :service_survey
  before_create :get_results_for_survey

  private

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
    people_count = rating_and_binary_answers(service_survey_id).select(:user_id).distinct.count
    positive_perception = (overall_effectiveness(service_survey_id)/people_count).to_i
    {:survey => {:positive => positive_perception,
                 :negative => "#{ 100 - positive_perception}"},
     :title => ServiceSurvey.find(service_survey_id).title,
     :people_count => people_count
    }
  end

  def overall_effectiveness(service_survey_id)
    rating_and_binary_answers(service_survey_id).map(&:score).sum.to_i
  end

  def rating_and_binary_answers(service_survey_id)
    get_service_survey(service_survey_id).rating_and_binary_answers
  end

  def get_service_survey(service_survey_id)
    ServiceSurvey.find(service_survey_id)
  end

end