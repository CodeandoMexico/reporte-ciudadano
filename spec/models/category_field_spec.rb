require 'spec_helper'

describe CategoryField do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:category_field)).to be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :name }
  end
  context 'associations' do
    it { should belong_to :category }
  end
  context 'methods' do
    let(:category_field) { create(:category_field) }

    it '#to_s returns the category field name' do
      expect(category_field.to_s).to eq category_field.name
    end
  end
end
