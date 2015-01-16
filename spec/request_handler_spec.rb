require 'spec_helper'

describe CropsterApi::RequestHandler do
  let(:request_handler){ CropsterApi::RequestHandler.new }
  let(:config){ double('Config') }

  before do
    allow(config).to receive(:auth).and_return({ basic_auth: { 
        :username=>ENV['USERNAME'],
        :password=>ENV['PASSWORD']
      }
    })

    allow(config).to receive(:groupcode).and_return(ENV['GROUPCODE'])
  end

  it 'handles requests' do
    response = request_handler.trigger(config)
    expect(response.code).to eq 200
  end

  it 'formats hash params for http' do
    params = request_handler.parameterize_for_http(
      processingStep: 'coffee.roasting')

    expect(params).to eq "&processingStep=coffee.roasting"
  end

  it 'formats multiple hash params for http' do
    params = request_handler.parameterize_for_http(
      processingStep: 'coffee.roasting',
      location_id: 123)

    expect(params).to eq "&processingStep=coffee.roasting&location_id=123"
  end
end