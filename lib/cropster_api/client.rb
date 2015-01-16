require 'httparty'

module CropsterApi
  class Client
    include HTTParty
    base_uri 'https://c-sar.cropster.com/api/rest/v1'

    attr_reader :username, :password, :groupcode
    
    def initialize opts={}
      @username = opts[:username]
      @password = opts[:password]
      @groupcode = opts[:groupcode]
    end

    def basic_auth
      {:username => username, :password => password}
    end

    def roasted_lots opts={}
      auth = opts.merge({ :basic_auth => basic_auth })
      
      self.class.get("/lot?groupCode=#{groupcode}&processingStep=coffee.roasting", auth)
    end

    def green_lots
      self.class.get("lot?groupCode=#{groupcode}&locationId=62205&processingStep=coffee.green")
    end
  end
end