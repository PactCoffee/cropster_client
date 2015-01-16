module CropsterApi
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
end