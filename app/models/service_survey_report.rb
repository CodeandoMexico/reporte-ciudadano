class ServiceSurveyReport < ActiveRecord::Base
  belongs_to :service_survey
  validates :answers_exist, presence: true
  before_create :set_results_for_report
  serialize :areas_results, Hash


  def service_survey_title
    service_survey.title
  end

  def service_survey_phase
    service_survey.phase
  end

  private

  def answers_exist
    rating_and_binary_answers(self.service_survey_id)
  end

  def set_results_for_report
    survey_report = report(self.service_survey_id)
    survey = get_service_survey(self.service_survey_id)
    self.positive_overall_perception = survey_report[:survey][:positive]
    self.negative_overall_perception = survey_report[:survey][:negative]
    self.service_survey_id = survey.id
    self.people_who_participated = survey_report[:people_count]
    self.areas_results = survey_report[:overall_areas]
  end

  def report(service_survey_id)
     survey_results = effectiveness_survey(service_survey_id)
     overall_areas = effectiveness_by_criterion(service_survey_id)
     {}.merge(survey_results).merge(:overall_areas => overall_areas)
  end

  def effectiveness_survey(service_survey_id)
    people_count = people_count(service_survey_id)
    positive_perception = (overall_effectiveness(service_survey_id)/people_count).to_i
    {:survey => {:positive => positive_perception,
                 :negative => "#{ 100 - positive_perception}"},
     :title => ServiceSurvey.find(service_survey_id).title,
     :people_count => people_count
    }
  end

  def people_count(service_survey_id)
    rating_and_binary_answers(service_survey_id).select(:user_id).distinct.count
  end

  def effectiveness_by_criterion(service_survey_id)
    criteria = ServiceSurveys.criterion_options_available
    answers = rating_and_binary_answers(service_survey_id).includes(:question).inject([]) do |result, survey_answer|
      result << [survey_answer.question.criterion, survey_answer.score/survey_answer.question.value.to_f*100 ] if survey_answer.question.value > 0
      result
    end
    results = {}
    people_count = people_count(service_survey_id)
    criteria.each do |c|
      answers_list = answers.clone
      total_by_criterion = total_by_area(answers_list, c, {:count =>0, :acc=>0})
      if people_count * total_by_criterion[:count] > 0
        results[c] = total_by_criterion[:acc] / (people_count * total_by_criterion[:count])
      else
        results[c] = 0
      end
    end
    results
  end

  def total_by_area(answers_list, key, result)
    return result if answers_list.empty?
    next_key, next_key_value = answers_list.shift
    if next_key.to_sym == key
      result[:count] += 1
      result[:acc] += next_key_value
      total_by_area(answers_list, key, result)
    else
      total_by_area(answers_list, key, result)
    end
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