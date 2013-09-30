require 'spec_helper'

describe Vote do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:vote)).to be_valid
    end
    it 'is invalid when a repeating the vote by a voter' do
      vote = create(:vote)
      expect(build(:vote, voter: vote.voter, voteable: vote.voteable)).to_not be_valid
    end
  end

  context 'attributes' do
    it { should respond_to :vote }
    it { should respond_to :voteable }
    it { should respond_to :voter }
  end
  context 'associations' do
    it { should belong_to :voter }
    it { should belong_to :voteable }
  end

  context 'scopes' do
    let(:votes) { [create(:vote), create(:vote), create(:vote)]}

    it '.for_voter returns all the votes done by a resource' do
      expect(Vote.for_voter(votes.first.voter)).to eq([votes.first])
    end

    it '.for_voteable returns all the votes done on a certain resource' do
      expect(Vote.for_voteable(votes.first.voteable)).to eq([votes.first])
    end

    it '.recent returns votes created from two weeks ago until now' do
      count = votes.size
      expect(Vote.recent.count).to eq(count)
    end

    it '.descending returns all votes ordered descending by created_at' do
      expect(Vote.descending).to eq(votes.reverse)
    end
  end
end
