module CropsterApi
  class RequestHandler
    include HTTParty
    include CropsterApi::Helpers

    BASE = 'c-sar.cropster.com/api/rest/'
    VERSION = 'v1'

    base_uri "https://#{BASE}#{VERSION}"

    attr_reader :config, :type, :lot_id, :params, :http_params

    def trigger config, params={}
      @config = config
      @type = params.extract!(:type)[:type]
      @lot_id = params.extract!(:lot_id)[:lot_id]
      @params = params
      @http_params = parameterize_for_http

      url = generate_url
      self.class.get(url, config.auth)
    end

    def parameterize_for_http
      return "" if params.blank?
      params.to_a.reduce(""){ |str,v| str+="&#{camelize(v[0])}=#{v[1]}" }
    end

    def generate_url
      raise ArgumentError, "'type' missing" if type.nil?

      case type
        when 'single lot'
          return lot_url
        when 'all lots'
          return all_lots_url
        when 'location'
          return location_url
        else
          raise ArgumentError, "'type' not recognised, please specify 'single lot', 'all lots' or 'location'"
      end
    end

    def lot_url
      errors = []
      errors << "'lot_id' missing" if lot_id.nil?
      errors << "'lot_id' should be an integer" unless is_integer?(lot_id)

      raise ArgumentError, errors.join(", ") unless errors.empty?

      "/lot/#{lot_id}/transaction"
    end

    def all_lots_url
      "/lot?groupCode=#{config.groupcode}#{http_params}"
    end

    def location_url
      "/location?groupCode=#{config.groupcode}#{http_params}"
    end
  end
end