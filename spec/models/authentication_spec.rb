require 'spec_helper'

describe Authentication do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:authentication)).to be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :provider }
    it { should respond_to :uid }
  end
  context 'associations' do
    it { should belong_to :user }
  end
  context 'methods' do
    let!(:authentication) { create(:authentication) }

    describe '.find_with_omniauth' do
      it 'returns an authentication found by provider and uid' do
        auth = Authentication.find_with_omniauth(omniauth_facebook_valid_hash)
        expect(auth.uid).to eq(omniauth_facebook_valid_hash.uid)
      end
    end
  end
end
