module CropsterApi
  class Config
    attr_accessor :username, :password, :groupcode

    def auth
      { basic_auth: {:username => username, :password => password} }
    end
  end
end