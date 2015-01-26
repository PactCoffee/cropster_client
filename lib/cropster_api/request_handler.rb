module CropsterApi
  class RequestHandler
    include HTTParty

    BASE = 'c-sar.cropster.com/api/rest/'
    VERSION = 'v1'

    base_uri "https://#{BASE}#{VERSION}"

    attr_reader :config, :type, :params

    def trigger config, params={}
      @config = config
      @type = params.extract!(:type)[:type]
      @params = params

      url = generate_url
      self.class.get(url, config.auth)
    end

    def parameterize_for_http
      return "" if @params.blank?
      @params.to_a.reduce(""){ |str,val| str+="&#{val[0].to_s.camelize(:lower)}=#{val[1]}" }
    end

    def generate_url
      raise ArgumentError, "'type' missing" if @type.nil?

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
      lot_id = @params[:lot_id]

      errors = []
      errors << "'lot_id' missing" if lot_id.nil?
      errors << "'lot_id' should be an integer" unless is_integer?(lot_id)

      raise ArgumentError, errors.join(", ") unless errors.empty?

      "/lot/#{lot_id}/transaction"
    end

    def all_lots_url
      @params = parameterize_for_http
      "/lot?groupCode=#{config.groupcode}#{@params}"
    end

    def location_url
      @params = parameterize_for_http
      "/location?groupCode=#{config.groupcode}#{@params}"
    end

    def is_integer?(num)
      num.class.name == 'Fixnum' || lot_id.match(/\A[-+]?\d+\z/)
    end
  end
end