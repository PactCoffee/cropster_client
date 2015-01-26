module CropsterApi
  class RequestHandler
    include HTTParty
    base_uri 'https://c-sar.cropster.com/api/rest/v1'

    def trigger config, params={}
      url = generate_url(params)
      # params = parameterize_for_http(params)
      self.class.get("/lot?groupCode=#{config.groupcode}", config.auth)
    end

    def parameterize_for_http(params={})
      return "" if params.empty?
      params.to_a.reduce(""){ |str,val| str+="&#{val[0].to_s.camelize(:lower)}=#{val[1]}" }
    end

    def generate_url(params={})
      type = params.extract!(:type)[:type]
      puts type.inspect
      raise ArgumentError, "'type' missing" if type.nil?

      case type
        when 'single lot'
          return lot_url(params)
        when 'all lots'
          return all_lots_url(params)
        when 'location'
          return location_url(params)
        else
          raise ArgumentError, "'type' not recognised, please specify 'single lot', 'all lots' or 'location'"
      end
    end

    def lot_url(params={})
      lot_id = params[:lot_id]

      errors = []
      errors << "'lot_id' missing" if lot_id.nil?
      errors << "'lot_id' should be an integer" unless is_integer?(lot_id)

      raise ArgumentError, errors.join(", ") unless errors.empty?

      "lot/#{lot_id}/transaction"
    end

    def all_lots_url(params={})
      params = parameterize_for_http(params)
      "lot?groupCode=#{ENV['GROUPCODE']}#{params}"
    end

    def location_url(params={})
      "location?groupCode=#{ENV['GROUPCODE']}"
    end

    def is_integer?(num)
      num.class.name == 'Fixnum' || lot_id.match(/\A[-+]?\d+\z/)
    end
  end
end