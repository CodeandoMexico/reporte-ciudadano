require 'spec_helper'

describe Status do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:status)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_status)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :name }
    it { should respond_to :is_default }
  end
  context 'associations' do
    it { should have_many :service_requests }
    it { should have_many :messages }
  end
  context 'methods' do
    let(:status) { create(:status) }

    it '#to_s returns the status name' do
      expect(status.to_s).to eq(status.name)
    end
  end
  context 'scopes' do
    let(:statuses) {[]}

    before :each do
      3.times {|n| statuses << create(:status, created_at: n.days.ago)}
    end

    it '.default_scope returns the statuses ordered by descending created_at' do
      expect(Status.all).to eq(statuses.reverse)
    end
  end
end
