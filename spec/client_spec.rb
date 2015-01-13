require 'spec_helper'

describe CropsterApi::Client do 
  it 'should initialize with an options hash' do
    client = CropsterApi::Client.new({ username: 'foo', password: 'bar' })
    
    expect(client.username).to eq 'foo'
    expect(client.password).to eq 'bar'
  end
end