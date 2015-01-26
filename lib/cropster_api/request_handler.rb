module CropsterApi
  class RequestHandler
    include HTTParty
    base_uri 'https://c-sar.cropster.com/api/rest/v1'

    def trigger config, params={}
      params = parameterize_for_http(params) 
      self.class.get("/lot?groupCode=#{config.groupcode}#{params}", config.auth)
    end

    def parameterize_for_http(params={})
      return "" if params.empty?
      params.to_a.reduce(""){ |str,val| str+="&#{val[0]}=#{val[1]}" }
    end
  end
end