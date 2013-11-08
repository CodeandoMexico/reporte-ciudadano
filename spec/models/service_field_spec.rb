require 'spec_helper'

describe ServiceField do
  context 'factories' do
    it 'has a valid factory' do
      expect(build(:service_field)).to be_valid
    end
  end
  context 'attributes' do
    it { should respond_to :name }
  end
  context 'associations' do
    it { should belong_to :service }
  end
  context 'methods' do
    let(:service_field) { create(:service_field) }

    it '#to_s returns the service field name' do
      expect(service_field.to_s).to eq service_field.name
    end
  end
end
