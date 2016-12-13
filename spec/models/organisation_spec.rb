require 'rails_helper'

RSpec.describe Organisation, type: :model do

  let(:organisation) { FactoryGirl.build(:organisation) }

  subject { organisation }

  context 'attributes' do
    it { should respond_to :name }
  end

  context 'associations' do
    it { should have_many :admins }
    it { should have_many :agencies }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should be_valid }
  end

end
