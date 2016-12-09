require 'spec_helper'

describe Admin do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:admin)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_admin)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :avatar }
    it { should respond_to :name }
    it { should respond_to :email }
    it { should respond_to :authentication_token }
  end
  context 'associations' do
    it { should have_many :comments }
    it { should have_many :service_requests }
    it { should have_many :service_request_readings }
    it { should have_one :api_key }
  end
  context 'methods' do
    let(:admin) { create(:admin) }
    it '#to_s returns email' do
      expect(admin.to_s).to eq admin.email
    end
    it '#api_key?' do
      create(:api_key, admin: admin)
      expect(admin.api_key?).to be
    end
  end
end
