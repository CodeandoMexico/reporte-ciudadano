require 'spec_helper'

describe ServiceRequestSerializer do
  let(:json_serializer) { JSON.parse ServiceRequestSerializer.new(FactoryGirl.create(:service_request)).to_json }

  it 'has request as its root key' do
    expect(json_serializer).to have_key('request')
  end

  it 'has a service_request_id key' do
    expect(json_serializer['request']).to have_key('service_request_id')
  end

  it 'has a status key' do
    expect(json_serializer['request']).to have_key('status')
  end

  it 'has a status_notes key' do
    expect(json_serializer['request']).to have_key('status_notes')
  end

  it 'has a service_name key' do
    expect(json_serializer['request']).to have_key('service_name')
  end

  it 'has a service_code key' do
    expect(json_serializer['request']).to have_key('service_code')
  end

  it 'has a description key' do
    expect(json_serializer['request']).to have_key('description')
  end

  it 'has a requested_datetime key' do
    expect(json_serializer['request']).to have_key('requested_datetime')
  end

  it 'has a updated_datetime key' do
    expect(json_serializer['request']).to have_key('updated_datetime')
  end

  it 'has a address key' do
    expect(json_serializer['request']).to have_key('address')
  end

  it 'has a media_url key' do
    expect(json_serializer['request']).to have_key('media_url')
  end

end
