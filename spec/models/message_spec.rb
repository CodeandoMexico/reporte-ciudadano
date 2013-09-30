require 'spec_helper'

describe Message do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:message)).to be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :content }
    it { should respond_to :status }
    it { should respond_to :category }
  end
  context 'associations' do
    it { should belong_to :category }
    it { should belong_to :status }
  end
  context 'scopes' do
    it '.with_status returns messages related to a status' do
      status = create(:status)
      messages = [create(:message, status: status), create(:message), create(:message)]
      expect(Message.with_status(status)).to eq([messages.first])
    end
  end
end
