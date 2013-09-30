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
    let(:authentication) { create(:authentication) }
    it '.create_with_omniauth returns a new authentication from omniauth' do
      expect do
        Authentication.create_with_omniauth(omniauth_facebook_valid_hash)
      end.to change{Authentication.count}.from(0).to(1)
    end

    it '.find_for_provider_oauth returns an authentication from omniauth' do
      user = create(:user)
      auth = Authentication.find_for_provider_oauth(omniauth_facebook_valid_hash, user)
      expect(auth.user.id).not_to be_nil
    end
  end
end
