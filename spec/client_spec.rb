require 'spec_helper'

describe CropsterApi::Client do
  it 'should initialize with an options hash' do
    client = CropsterApi::Client.new({ username: 'foo', password: 'bar' })
    
    expect(client.username).to eq 'foo'
    expect(client.password).to eq 'bar'
  end

  # describe "basic_auth" do
  #   context "authorised" do
  #   end

  #   context "unauthorised" do
  #   end
  # end

  describe '#roasted_lots' do
    let(:client){ CropsterApi::Client.new({ username: ENV['USERNAME'], password: ENV['PASSWORD'] }) }
    
    it "retrieves roasted lots" do
      response = client.roasted_lots
      expect(response.code).to eq 200
    end
  end
end