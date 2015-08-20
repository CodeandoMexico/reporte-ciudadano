require 'spec_helper'

feature 'Observer sees service evaluation' do
  let(:observer) { create(:user, :observer) }

  scenario 'from cis results with every answer', js: true  do
    user = create :user
    other_user = create :user
    service = create :service, name: "Actas de nacimiento", cis: ["1"], admins: [create(:admin, :public_servant)]
    other_survey = create(:survey_with_multiple_questions, services: [service], title: "Obtención de acta de nacimiento", phase: "start", open: true)
    survey = create(:survey_with_multiple_questions, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)

    given_survey_has_answers_for(survey, user: user, binary: "Sí", rating: "Regular", list: "Custom", open: "Mis sugerencias", score: 1.0 )
    given_survey_has_answers_for(survey, user: other_user, binary: "No", rating: "Muy Satisfecho", list: "Una respuesta", open: "Mis sugerencias y comentarios", score: 0.0 )
    given_survey_has_answers_for(other_survey, user: user, binary: "Sí", rating: "Satisfecho", list: "Mi respuesta", open: "Mis sugerencias y comentarios", score: 1.0 )
    given_survey_report_exists_for survey
    given_survey_report_exists_for other_survey

    sign_in_user observer
    visit cis_evaluation_path(id: 1)
    sleep 2.5

    within service_row(1) do
      click_link "Ver respuestas de servicio"
    end

    sleep 3
    expect(page).to have_content "Actas de nacimiento"
    expect(page).to have_content "Encuesta acta de nacimiento"
    expect(page).to have_content user.name
    expect(page).to have_content other_user.name

    survey.questions.each do |question|
      expect(page).to have_content question.text.truncate(18)
    end

    survey.answers.each do |answer|
      expect(page).to have_content answer.text
    end

    click_button "Ver respuestas de otras encuestas"
    sleep 3
    click_link "Obtención de acta de nacimiento"
    sleep 3

    expect(page).to have_content "Actas de nacimiento"
    expect(page).to have_content "Obtención de acta de nacimiento"
    expect(page).to have_content user.name
    expect(page).not_to have_content other_user.name

    other_survey.questions.each do |question|
      expect(page).to have_content question.text.truncate(18)
    end

    other_survey.answers.each do |answer|
      expect(page).to have_content answer.text
    end
  end

  def given_survey_has_answers_for(survey, answers_data)
    survey.questions.each do |question|
      if [:binary, :rating].include? question.answer_type.to_sym
        SurveyAnswer.create!(text: answers_data[question.answer_type.to_sym], question_id: question.id, score: answers_data[:score] * question.value, user_id: answers_data[:user].id)
      else
        SurveyAnswer.create!(text: answers_data[question.answer_type.to_sym], question_id: question.id, score: nil, user_id: answers_data[:user].id)
      end
    end
  end

  def given_survey_report_exists_for(survey)
    ServiceSurveyReport.create!(service_survey_id: survey.id)
  end

  def service_row(row)
    all("tbody tr")[row - 1]
  end
end