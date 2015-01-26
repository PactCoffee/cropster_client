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

      expect(params).to eq "&processingStep=coffee.roasting&location_id=123"
    end

    context 'for transactions' do
      it 'generates the correct url' do
        url = request_handler.generate_transaction_url(
          transaction: true,
          lotId: 123)

        expect(url).to eq 'lot/123/transaction'
      end
    end

    context 'for non-transaction requests' do
      it 'generates the correct url' do
        url = request_handler.generate_transaction_url(
          processingStep: 'coffee.roasting',
          location_id: 123)

        expect(url).to eq "lot?groupCode=#{ENV['GROUPCODE']}&lot/123/transaction"
      end
    end
  end
end