module CropsterApi
  class Client
    class << self
      attr_reader :config, :request_handler, :response_handler

      def configure
        raise ArgumentError, "block not given" unless block_given?

        @config = Config.new
        @request_handler = RequestHandler.new
        @response_handler = ResponseHandler.new

        yield config
      end

      def request params={}
        response = request_handler.trigger(config, params)
        response_handler.handle_response(response)
      end

      # def green_lots
      #   self.class.get("lot?groupCode=#{config.groupcode}&locationId=62205&processingStep=coffee.green")
      # end
    end
  end
end