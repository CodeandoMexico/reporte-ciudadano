require_relative 'cis_with_results_spec'
module Evaluations

  describe 'csv summary answers' do
    class TestUser
      attr_accessor :id, :name, :email

      def initialize(attrs)
        @id = attrs[:id]
        @name = attrs[:name]
        @email = attrs[:email]
      end
    end

    class TestSurvey
      attr_accessor :title, :questions, :respondents, :answers

      def initialize(attrs)
        @title = attrs[:title]
        @questions = attrs[:questions] || []
        @respondents = attrs[:respondents] || []
        @answers = attrs[:answers] || []
      end

      def answers_are_being_ignored_for(user_id)
        answers.select { |answer| answer.user_id == user_id}.any?(&:ignored)
      end
    end

    it 'has a custom name' do
      service_survey = double 'survey', title: "Mi encuesta", questions: [], respondents: []
      filename = csv_summary_answers_filename_for(service_survey)
      expect(filename).to eq "respuestas_encuesta_Mi_encuesta.csv"
    end

    describe 'each row' do
      describe 'has the users answers' do
        attr_reader :report

        before :all do
          respondents = [ TestUser.new(id: "user-id", name: "Juan Soto") ]
          answers = [TestAnswer.new(text: "Muy bueno", user_id: "user-id", ignored: true)]
          second_answers = [TestAnswer.new(text: "Muy malo", user_id: "user-id", ignored: false)]
          questions = [ TestQuestion.new(text: "Una pregunta ?", answers: answers), TestQuestion.new(text: "Otra pregunta ?", answers: second_answers) ]
          service_survey = TestSurvey.new(title: "Mi encuesta", questions: questions, respondents: respondents, answers: answers + second_answers)
          @report = csv_summary_answers(service_survey)
        end

        it { expect(column(report, 'Usuario')).to include "Juan Soto" }
        it { expect(column(report, 'Una pregunta ?')).to include "Muy bueno" }
        it { expect(column(report, 'Otra pregunta ?')).to include "Muy malo" }
        it { expect(column(report, 'Ignoradas')).to include "Sí" }
      end
    end

    def csv_summary_answers(service_survey)
      csv_file, filename = Evaluations.csv_summary_answers(service_survey)
      csv_file
    end

    def csv_summary_answers_filename_for(service_survey)
      csv_file, filename = Evaluations.csv_summary_answers(service_survey)
      filename
    end

    def column(csv_file, column_name)
      column = CSV.
        parse(csv_file).
        transpose.
        select { |column| column[0] == column_name }.
        first

      raise "No column named '#{column_name}'" unless column
      column.reject { |cell| cell == column_name }
    end
  end
end
