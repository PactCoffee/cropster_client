module CropsterApi
  class Client
    attr_reader :username, :password
    
    def initialize opts={}
      @username = opts[:username]
      @password = opts[:password]
    end
  end
end