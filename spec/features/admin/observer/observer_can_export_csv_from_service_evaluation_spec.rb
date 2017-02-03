require 'spec_helper'

feature 'Observer can export csv from service evaluation' do
  let(:observer) { create(:observer) }

  scenario 'from cis results with every answer' do
    user = create :user, name: nil
    service = create :service, name: "Actas de nacimiento", cis: ["1"], admins: [create(:admin, :public_servant)]
    survey = create(:survey_with_multiple_questions, services: [service], title: "Encuesta acta de nacimiento", phase: "start", open: true)

    given_survey_has_answers_for(survey, user: user, binary: "Sí", rating: "Regular", list: "Custom", open: "Mis sugerencias", score: 1.0 )

    sign_in_admin observer
    visit service_evaluation_path(service)
    click_link "Exportar CSV"

    expect(exported_csv_name).to include "respuestas_encuesta_#{survey.title.gsub(" ", "_")}.csv"
    expect_exported_csv_with(
      [["Usuario", user.email]] +
      questions_and_answers(survey, user) +
      [["Ignoradas", "No"]]
    )
  end

  def questions_and_answers(survey, user)
    survey
      .questions
      .map { |question| [question.text, question.survey_answer_by_user(user.id).text]}
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

  def expect_exported_csv_with(csv_array)
    csv = []
    CSV.parse(page.body) { |row| csv << row }
    expect(csv).to eq csv_array.transpose
  end

  def exported_csv_name
    page.response_headers['Content-Disposition']
  end
end