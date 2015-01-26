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
    response = request_handler.trigger(config, {type: 'all lots'})
    expect(response.code).to eq 200
  end

  describe 'dynamic url generation' do
    it 'formats hash params for http' do
      params = request_handler.parameterize_for_http(
        processingStep: 'coffee.roasting')

      expect(params).to eq "&processingStep=coffee.roasting"
    end

    it 'formats multiple hash params for http' do
      params = request_handler.parameterize_for_http(
        processingStep: 'coffee.roasting',
        location_id: 123)

      expect(params).to eq "&processingStep=coffee.roasting&locationId=123"
    end

    describe 'for a specific lot' do
      it 'generates the correct url' do
        url = request_handler.generate_url(
          type: 'single lot',
          lot_id: 123
        )

        expect(url).to eq 'lot/123/transaction'
      end
    end

    describe 'for all lots' do
      it 'generates the correct url' do
        url = request_handler.generate_url(
          type: 'all lots'
        )

        expect(url).to eq "lot?groupCode=#{ENV['GROUPCODE']}"
      end

      it 'accepts params' do
        url = request_handler.generate_url(
          type: 'all lots',
          location_id: 123,
          processing_step: 'coffee.roasting'
        )

        expect(url).to eq "lot?groupCode=#{ENV['GROUPCODE']}&locationId=123&processingStep=coffee.roasting"
      end
    end

    describe 'for locations' do
    it 'generates the correct url' do
        url = request_handler.generate_url(
          type: 'location'
        )

        expect(url).to eq "location?groupCode=#{ENV['GROUPCODE']}"
      end
    end
  end
end