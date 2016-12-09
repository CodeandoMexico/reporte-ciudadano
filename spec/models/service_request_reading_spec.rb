require 'rails_helper'

RSpec.describe ServiceRequestReading, type: :model do
  let(:service_request_reading) { build(:service_request_reading) }
  subject { service_request_reading }

  context 'validations' do
    it { should be_valid }
  end

  context 'associations' do
    it { should belong_to :service_request }
    it { should belong_to :admin }
  end

end
