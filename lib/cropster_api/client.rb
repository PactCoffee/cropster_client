module CropsterApi
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