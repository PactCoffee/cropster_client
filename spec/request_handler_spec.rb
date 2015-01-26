require 'spec_helper'

def set_var(var, val)
  request_handler.instance_variable_set(var, val)
end

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
    set_var(:@config, config)
  end

  it 'handles requests - all lots' do
    response = request_handler.trigger(config, { type: 'all lots' })
    expect(response.code).to eq 200
  end

  it 'handles requests - locations' do
    response = request_handler.trigger(config, { type: 'location' })
    expect(response.code).to eq 200
  end

  describe 'dynamic url generation' do
    it 'formats hash params for http' do
      set_var(:@params, { processingStep: 'coffee.roasting' })

      http_params = request_handler.parameterize_for_http
      expect(http_params).to eq "&processingStep=coffee.roasting"
    end

    it 'formats multiple hash params for http' do
      set_var(:@params, { processingStep: 'coffee.roasting', location_id: 123 })

      http_params = request_handler.parameterize_for_http
      expect(http_params).to eq "&processingStep=coffee.roasting&locationId=123"
    end

    describe 'for a specific lot' do
      it 'generates the correct url' do
        set_var(:@params, { lot_id: 123 })
        set_var(:@type, 'single lot')

        url = request_handler.generate_url
        expect(url).to eq '/lot/123/transaction'
      end
    end

    describe 'for all lots' do
      it 'generates the correct url' do
        set_var(:@type, 'all lots')
        
        url = request_handler.generate_url
        expect(url).to eq "/lot?groupCode=#{ENV['GROUPCODE']}"
      end

      it 'accepts params' do
        set_var(:@type, 'all lots')

        set_var(:@params, {
          location_id: 123,
          processing_step: 'coffee.roasting'
        })

        url = request_handler.generate_url
        expect(url).to eq "/lot?groupCode=#{ENV['GROUPCODE']}&locationId=123&processingStep=coffee.roasting"
      end
    end

    describe 'for locations' do
      it 'generates the correct url' do
        set_var(:@type, 'location')

        url = request_handler.generate_url
        expect(url).to eq "/location?groupCode=#{ENV['GROUPCODE']}"
      end
    end
  end
end