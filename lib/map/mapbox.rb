require "json"
require "net/http"

module Map
  class MapBox
    def self.map_call
      api = "https://api.mapbox.com/geocoding/v5/mapbox.places/Los%20Angeles.json?access_token=#{ENV['MAPBOX']}"
      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)
      JSON.parse(http_response.body)
    end
  end
end