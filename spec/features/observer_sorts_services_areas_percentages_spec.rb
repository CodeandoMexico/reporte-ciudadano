require 'spec_helper'

feature 'Observer sorts services areas percentages' do
  let(:observer) { create(:user, :observer) }

  scenario 'from cis evaluation', js: true do
    service = create :service, name: "Actas de nacimiento", cis: ["1", "2"], admins: [create(:admin, :public_servant)]
    other_service = create :service, name: "Licencias", cis: ["1"], admins: create_list(:admin, 2, :public_servant)
    survey = create(:survey_with_binary_question, services: [service, other_service], phase: "start", open: true)
    other_survey = create(:survey_with_binary_question, services: [other_service], phase: "start", open: true)
    given_questions_has_answers 4, survey.questions, score: 1
    given_questions_has_answers 4, other_survey.questions, score: 0.5
    given_survey_report_exists_for survey
    given_survey_report_exists_for other_survey

    sign_in_user observer
    visit cis_evaluation_path(id: 1)
    sleep 1.5

    within '.evaluation-services' do
      expect(service_row 1).to have_content "Actas de nacimiento"
      expect(service_row 2).to have_content "Licencias"

      click_link "Transparencia"
      sleep 1.5
      expect(service_row 1).to have_content "Licencias"
      expect(service_row 2).to have_content "Actas de nacimiento"

      click_link "Transparencia"
      sleep 1.5
      expect(service_row 1).to have_content "Actas de nacimiento"
      expect(service_row 2).to have_content "Licencias"
    end
  end

  def service_row(row)
    all("tbody tr")[row - 1]
  end

  def given_survey_report_exists_for(survey)
    ServiceSurveyReport.create!(service_survey_id: survey.id)
  end

  def given_questions_has_answers(answers_count, questions, score: 1)
    questions.each do |question|
      question.survey_answers = create_list(:survey_answer, answers_count, question_id: question.id, score: question.value * score)
      question.save
    end
  end
end