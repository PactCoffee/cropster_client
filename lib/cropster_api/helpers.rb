module CropsterApi
  module Helpers
    def is_integer?(num)
      num.class.name == 'Fixnum' || lot_id.match(/\A[-+]?\d+\z/)
    end

    def camelize(input)
      input.to_s.camelize(:lower)
    end
  end
end