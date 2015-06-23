require 'spec_helper'

feature 'Observer can see cis evaluation results' do
  let(:observer) { create(:user, :observer) }

  background do
    sign_in_user observer
  end

  scenario 'from dashboard' do
    service = create :service, name: "Actas de nacimiento"
    survey = create(:survey_with_binary_question, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)
    given_survey_has_answers survey

    expect(current_path).to eq cis_evaluations_path
    expect(page).to have_content "Centro 1"
    expect(page).to have_content "Centro 2"
    expect(page).to have_content "Centro 3"
    expect(page).to have_content "Centro 4"

    within first('.cis') do
      expect(page).to have_link "Ver resultados"
      click_link "Ver resultados"
    end
    save_and_open_page
    expect(current_path).to eq cis_evaluation_path(id: 1)
  end

  def given_survey_has_answers(survey)
    survey.questions.each do |question|
      user = create :user
      question.survey_answers = [ create(:survey_answer, question_id: question.id, score: question.value, user_id: user.id)]
      question.save
    end
  end
end