require 'spec_helper'

describe User do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_user)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :email }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
    it { should respond_to :remember_me }
    it { should respond_to :username }
    it { should respond_to :name }
  end
  context 'associations' do
    it { should have_many :authentications }
    it { should have_many :service_requests }
    it { should have_many :comments }
  end
  context 'methods' do
    let!(:user) { create(:user) }

    describe '.find_or_build_with_omniauth' do
      context 'when a user is already registered' do
        let!(:old_user) { create(:user, email: omniauth_facebook_valid_hash.info.email)}
        let!(:found_user) { User.find_or_build_with_omniauth(omniauth_facebook_valid_hash) }

        it 'returns the registered user' do
          expect(found_user.id).to eq(old_user.id)
        end

        it 'creates an authentication for the user' do
          expect(found_user.authentications.size).to eq(1)
        end

      end

      context 'with a new user' do
        let!(:new_user) { User.find_or_build_with_omniauth(omniauth_facebook_valid_hash) }

        it 'builds a new user with the omniauth data' do
          expect(new_user.email).to eq(omniauth_facebook_valid_hash.info.email)
        end

        it 'builds an authentication' do
          expect(new_user.authentications.size).to eq(1)
        end
      end
    end

    describe '#collect_omniauth_attributes' do
      before { user.collect_omniauth_attributes(omniauth_facebook_valid_hash) }

      it 'sets the omniauth name on the user' do
        expect(user.name).to eq(omniauth_facebook_valid_hash.info.name)
      end

      it 'sets the omniauth username on the user' do
        expect(user.username).to eq(omniauth_facebook_valid_hash.info.nickname)
      end
    end

    describe '#to_s' do
      it 'returns the user name' do
        expect(user.to_s).to eq user.name
      end
    end

    describe '#avatar_url' do
      it 'defaults to a picture from gravatar' do
        expect(user.avatar_url).to match(/gravatar/)
      end

      it 'returns twitter image url when authenticated by twitter' do
        user_from_twitter = User.find_or_build_with_omniauth(omniauth_twitter_valid_hash)
        user_from_twitter.save
        expect(user_from_twitter.avatar_url).to match(/twimg/)
      end

      it 'returns facebook profile picture when it was authenticated with FB' do
        user_from_facebook = User.find_or_build_with_omniauth(omniauth_facebook_valid_hash)
        user_from_facebook.save
        expect(user_from_facebook.avatar_url).to match(/facebook/)
      end

    end

  end
end
