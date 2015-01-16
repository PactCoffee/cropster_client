require 'httparty'

module CropsterApi
  class Config
    attr_accessor :username, :password, :groupcode

    def auth
      { basic_auth: {:username => username, :password => password} }
    end
  end

  class RequestHandler
    include HTTParty
    base_uri 'https://c-sar.cropster.com/api/rest/v1'

    def trigger config, params={}
      params = parameterize_for_http(params) 
      self.class.get("/lot?groupCode=#{config.groupcode}#{params}", config.auth)
    end

    def parameterize_for_http(params={})
      return "" if params == {}
      params.to_a.reduce(""){|str,v| str+="&#{v[0]}=#{v[1]}"}
    end
  end

  class Client
    class << self
      attr_reader :config, :request_handler

      def configure
        raise ArgumentError, "block not given" unless block_given?

        @config = Config.new
        @request_handler = RequestHandler.new

        yield config
      end

      def request params={}
        request_handler.trigger(config, params)
      end

      # def green_lots
      #   self.class.get("lot?groupCode=#{config.groupcode}&locationId=62205&processingStep=coffee.green")
      # end
    end
  end
end