require 'spec_helper'

describe Category do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:category)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_category)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :name }
  end
  context 'associations' do
    it { should have_many :category_fields }
    it { should have_many :messages }
  end
  context 'methods' do
    let(:category) { create(:category) }

    it '#category_fields_names returns a comma separated string with the category fields names' do
      2.times { |n| create(:category_field, name: "field_#{n}", category: category) }
      expect(category.category_fields_names).to eq "field_0, field_1"
    end
  end
end
