require 'spec_helper'

describe Report do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:report)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_report)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :anonymous }
    it { should respond_to :description }
    it { should respond_to :lat }
    it { should respond_to :lng }
    it { should respond_to :category_fields }
    it { should respond_to :address }
    it { should respond_to :message }
  end
  context 'associations' do
    it { should belong_to :category }
    it { should belong_to :reportable }
    it { should belong_to :status }
    it { should have_many :comments }
  end
  context 'scopes' do
    let(:reports) {[]}

    before :each do
      3.times { |n| reports << create(:report, created_at: n.days.ago)}
    end

    it '.default scope orders the reports by created date descending' do
      expect(Report.all).to eq(reports)
    end

    it '.on_start_date returns reports created from the desired dates onwards' do
      expect(Report.on_start_date(2.days.ago)).to eq([reports[0], reports[1]])
    end

    it '.on_finish_date returns reports created before the desired date' do
      expect(Report.on_finish_date(1.days.ago)).to eq([reports[1], reports[2]])
    end

    it '.on_category returns reports related to certain category' do
      categorized_reports = Report.on_category(reports.first.category)
      expect(categorized_reports).to eq([reports.first])
    end

    it '.find_by_ids returns reports with the ids' do
      reports_by_ids = Report.find_by_ids(reports.map(&:id).join(','))
      expect(reports_by_ids).to eq(reports)
    end
  end

  context :methods do
    let(:report) { create(:report) }

    it '#category? tells me if my report has a category' do
      expect(report.category?).to be_true
    end

    it '#reporter returns a hash with the avatar_url and name from the reporter' do
      reporter = {avatar_url: report.reportable.avatar_url, name: report.reportable.name}
      expect(report.reporter).to eq(reporter)
    end

    it '#reporter returns a hash with an anonymous user when no user detected' do
      anonymous_report = create(:report, anonymous: true, reportable: nil)
      reporter = {avatar_url: 'http://www.gravatar.com/avatar/foo', name: 'Anónimo'}
      expect(anonymous_report.reporter).to eq(reporter)
    end

    it '#date returns the report created date with date format' do
      expect(report.date).to eq(report.created_at.to_date)
    end

    it '.chart_data returns reports grouped by category' do
      data = Report.chart_data
      expect(data.to_a.count).to eq(Category.count)
    end

  end
end
