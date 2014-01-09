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
      service.reload
      expect(service.service_fields_names).to eq "field_0, field_1"
    end

    describe '.chart_data' do
      let!(:services) { create_list(:service, 2) }
      let!(:first_request) { create(:service_request, service: services.first) }
      let!(:second_request) { create(:service_request, service: services.last) }

      it 'returns all the services' do
        expect(Service.chart_data.to_a.count).to eq(Service.count)
      end

      it 'each service responds to a method for each status' do
        service = Service.chart_data.first
        expect(service).to respond_to("status_#{first_request.status.id}")
        expect(service).to respond_to("status_#{second_request.status.id}")
      end

      it 'shows the right count by status by service' do
        service = Service.chart_data.first
        expect(service.status_1.to_i).to eq(1)
        expect(service.status_2.to_i).to eq(0)
      end

    end

  end


end
