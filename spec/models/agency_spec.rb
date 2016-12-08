require 'rails_helper'

RSpec.describe Agency, type: :model do
  let(:agency) { FactoryGirl.build(:agency) }

  subject { agency }

  context 'attributes' do
    it { should respond_to :name }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should be_valid }
  end

  context 'associations' do
  end
end
