require 'httparty'

module CropsterApi
  class Config
    attr_accessor :username, :password, :groupcode

    def basic_auth
      {:username => username, :password => password}
    end
  end

  class Client
    include HTTParty
    base_uri 'https://c-sar.cropster.com/api/rest/v1'

    class << self
      attr_reader :config

      def configure
        raise ArgumentError, "block not given" unless block_given?

        @config = Config.new
        yield config
      end

      def auth
        { :basic_auth => config.basic_auth }
      end

      def roasted_lots params={}  
        params = parameterize_for_http(params)  

        self.get("/lot?groupCode=#{config.groupcode}#{params}", auth)
      end

      def parameterize_for_http(params={})
        params.to_a.reduce(""){|str,v| str+="&#{v[0]=v[1]}"}
      end

      # &processingStep=coffee.roasting

      # def green_lots
      #   self.class.get("lot?groupCode=#{config.groupcode}&locationId=62205&processingStep=coffee.green")
      # end
    end
  end
end