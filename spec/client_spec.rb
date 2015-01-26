require 'spec_helper'

def configure(client)
  client.configure do |config|
    config.username = ENV['USERNAME']
    config.password = ENV['PASSWORD']
    config.groupcode = ENV['GROUPCODE']
  end
end

describe CropsterApi::Client do
  let(:client){ CropsterApi::Client }
  let(:params){ {type: 'all lots'} }

  describe "#configuration" do
    context "errors" do
      it 'if configured without a block' do
        expect{ client.configure }.to raise_error(ArgumentError)
      end
    end

    it 'should configure with a block' do
      configure(client)
      config = client.config

      expect(config.username).to eq ENV['USERNAME']
      expect(config.password).to eq ENV['PASSWORD']
      expect(config.groupcode).to eq ENV['GROUPCODE']
    end
  end

  describe "#request" do
    it "#roasted_lots" do
      configure(client)
      response=client.request(params)

      expect(response.code).to eq 200
    end
  end

  # describe "basic_auth" do
  #   context "authorised" do
  #   end

  #   context "unauthorised" do
  #   end
  # end
end