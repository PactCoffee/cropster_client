module CropsterApi
  class ResponseHandler
    attr_reader :code, :body

    def handle_response(response)
      @code = response.code

      @body = response.map do |item|
        ResponseItem.new(item)
      end

      return self
    end
  end

  class ResponseItem
    def initialize(attrs)
      setup_attr_readers(attrs)
    end

    def setup_attr_readers(attrs)
      attrs.each do |attr, val|
        self.send(:eval, ("def #{attr};@#{attr};end"))
        instance_variable_set("@#{attr}", val)
      end
    end
  end
end