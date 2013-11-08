require 'spec_helper'

describe Service do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:service)).to be_valid
    end
    it 'has an invalid factory' do
      expect(build(:invalid_service)).to_not be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :name }
  end
  context 'associations' do
    it { should have_many :service_fields }
    it { should have_many :messages }
  end
  context 'methods' do
    let(:service) { create(:service) }

    it '#service_fields_names returns a comma separated string with the service fields names' do
      2.times { |n| create(:service_field, name: "field_#{n}", service: service) }
      expect(service.service_fields_names).to eq "field_0, field_1"
    end
  end
end
