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
    let(:user) { create(:user) }

    it '#to_s returns name' do
      expect(user.to_s).to eq user.name
    end

    it '#avatar_url returns a url to get the picture from gravatar' do
      expect(user.avatar_url).to match(/gravatar/)
    end

    context 'facebook' do
      it '.create_with_omniauth returns a new user instance from facebook' do
        User.create_with_omniauth(omniauth_facebook_valid_hash)
        expect(user.id).not_to be_nil
      end

      it '#avatar_url returns a url to get the picture from facebook' do
        user_from_facebook = User.create_with_omniauth(omniauth_facebook_valid_hash)
        expect(user_from_facebook.avatar_url).to match(/facebook/)
      end

    end

    context 'twitter' do
      before :each do
        Twitter.stub(:user).and_return user
        user.stub(:profile_image_url).and_return "https://si0.twimg.com/profile_images/2921081357/9e8b8662cd9c4c06887365d559e714a3.png"
      end

      it '.create_with_omniauth returns a new user instance from twitter' do
        User.create_with_omniauth(omniauth_twitter_valid_hash)
        expect(user.id).not_to be_nil
      end

      it '#avatar_url returns a url to get the picture from twitter' do
        user_from_twitter = User.create_with_omniauth(omniauth_twitter_valid_hash)
        expect(user_from_twitter.avatar_url).to match(/twimg/)
      end

    end




  end
end
