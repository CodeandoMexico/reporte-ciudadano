class ServiceSurveyReport < ActiveRecord::Base
  belongs_to :service_survey
  has_many :services, through: :service_survey

  validates :existing_answers, presence: true

  before_create :compute_and_set_results_for_report

  serialize :areas_results, Hash

  def service_survey_title
    service_survey.title
  end

  def service_survey_phase
    service_survey.phase
  end

  def total_by_question
    questions_avg_score = rating_and_binary_answers(self.service_survey_id, self.cis_id, self.service_id)
        .group('questions.id')
        .average('survey_answers.score')
    questions = rating_and_binary_questions(self.service_survey_id).order(:criterion)
    {}.merge(:scores => questions_avg_score).merge(:questions => questions)
  end



  private

  def compute_and_set_results_for_report
    survey_report = compute_report_hash_for(self.service_survey_id, self.cis_id, self.service_id)
    self.positive_overall_perception = survey_report[:survey][:positive]
    self.negative_overall_perception = survey_report[:survey][:negative]
    self.people_who_participated = survey_report[:people_count]
    self.areas_results = survey_report[:overall_areas]
  end

  def compute_report_hash_for(service_survey_id, cis_id, service_id)
    survey_results = compute_overall_effectiveness_for(service_survey_id, cis_id, service_id)
    overall_areas = compute_effectiveness_by_criterion_for(service_survey_id, cis_id, service_id)
    {}.merge(survey_results).merge(:overall_areas => overall_areas)
  end


  def compute_overall_effectiveness_for(service_survey_id, cis_id, service_id)
    people_count = compute_people_count_for(service_survey_id, cis_id, service_id)
    positive_perception = (answers_sum(service_survey_id, cis_id, service_id)/people_count).to_i
    {:survey => {:positive => positive_perception,
                 :negative => "#{ 100 - positive_perception}"},
     :title => ServiceSurvey.find(service_survey_id).title,
     :people_count => people_count
    }
  end

  def compute_people_count_for(service_survey_id, cis_id, service_id)
    rating_and_binary_answers(service_survey_id, cis_id, service_id).select(:user_id).distinct.count
  end

  def compute_effectiveness_by_criterion_for(service_survey_id, cis_id, service_id)
    criteria = available_criteria
    answers = rating_and_binary_answers(service_survey_id, cis_id, service_id).includes(:question).inject([]) do |result, survey_answer|
              result << [survey_answer.question.criterion, survey_answer.score/survey_answer.question.value.to_f*100 ] if survey_answer.question.value > 0
              result
            end
    results = {}
    people_count = compute_people_count_for(service_survey_id, cis_id, service_id)
    criteria.each do |c|
      answers_list = answers.clone
      total_by_criterion = compute_total_by_area(answers_list, c, {:count =>0, :acc=>0})
      if people_count * total_by_criterion[:count] > 0
        results[c] = total_by_criterion[:acc] / (total_by_criterion[:count])
      else
        results[c] = 0
      end
    end
    results
  end


  def compute_total_by_area(answers_list, key, result)
    return result if answers_list.empty?
    next_key, next_key_value = answers_list.shift
    if next_key.to_sym == key
      result[:count] += 1
      result[:acc] += next_key_value
      compute_total_by_area(answers_list, key, result)
    else
      compute_total_by_area(answers_list, key, result)
    end
  end

  def existing_answers
    rating_and_binary_answers(self.service_survey_id, self.cis_id, self.service_id)
  end

  def available_criteria
    ServiceSurveys.criterion_options_available
  end

  def answers_sum(service_survey_id, cis_id, service_id)
    rating_and_binary_answers(service_survey_id, cis_id, service_id).map(&:score).sum.to_i
  end

  def rating_and_binary_questions(service_survey_id)
    get_service_survey(service_survey_id).questions.where(answer_type: ['rating','binary'])
  end

  def rating_and_binary_answers(service_survey_id, cis_id, service_id)
    get_service_survey(service_survey_id).rating_and_binary_answers.where(cis_id: cis_id, service_id: service_id)
  end

  def get_service_survey(service_survey_id)
    ServiceSurvey.find(service_survey_id)
  end
end