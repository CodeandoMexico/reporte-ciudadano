module Evaluations
  class SurveyReportFile
    def initialize(service_survey)
      @service_survey = service_survey
      @questions = service_survey.questions || []
    end

    def to_csv
      Report.new(filename, columns_headers, rows).to_csv
    end

    private

    attr_reader :service_survey, :questions

    def rows
      service_survey.respondents.map do |respondent|
        row_for(respondent)
      end
    end

    def filename
      "respuestas_encuesta_#{service_survey.title.gsub(" ", "_")}.csv"
    end

    def columns
      [:user, questions.map(&:text), :ignored].flatten
    end

    def columns_headers
      columns.map do |column|
        {
          user: "Usuario",
          ignored: "Ignoradas"
        }.fetch(column) { column }
      end
    end

    def row_for(user_record)
      [user_record.name || user_record.email] +
      answers_for_question(user_record) +
      ignored_answers_for_user(user_record.id)
    end

    def ignored_answers_for_user(user_id)
      if service_survey.answers_are_being_ignored_for(user_id)
        ["Sí"]
      else
        ["No"]
      end
    end

    def answers_for_question(user_record)
      questions.map { |question| question.survey_answer_by_user(user_record.id).text }
    end
  end
end