require 'spec_helper'

describe Comment do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:comment)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_comment)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :content }
    it { should respond_to :service_request }
    it { should respond_to :image }
    it { should respond_to :commentable }
    it { should respond_to :ancestry }
    it { should respond_to :image }
  end
  context 'associations' do
    it { should belong_to :commentable }
    it { should belong_to :service_request }
  end
end
