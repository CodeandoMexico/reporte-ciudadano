require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { FactoryGirl.build(:office) }

  subject { office }

  context 'attributes' do
    it { should respond_to :name }
    it { should respond_to :address }
    it { should respond_to :phone }
    it { should respond_to :schedule }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should be_valid }
  end
end
