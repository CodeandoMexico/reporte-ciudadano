require 'spec_helper'

describe ApiKey do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:api_key)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_api_key)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :access_token }
  end
  context 'methods' do
    it '#to_s returns access_token' do
      api_key = create(:api_key)
      expect(api_key.to_s).to eq api_key.access_token
    end
  end
  context 'associations' do
    it { should belong_to :admin }
  end
end
