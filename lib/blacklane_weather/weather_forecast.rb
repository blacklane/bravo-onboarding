# frozen_string_literal: true

require "json"
require "open-uri"
require "./lib/errors/invalid_city_error"
require "net/http"
require_relative "temperature_data"

module BlacklaneWeather
  class WeatherForecast
    attr_reader :city

    def initialize(city)
      @city = city
    end

    def weather_call
      coordinates = location_coordinates
      api = "http://api.openweathermap.org/data/2.5/weather?lat=#{coordinates[:lat]}&lon=#{coordinates[:lon]}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"

      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)
      weather_data = JSON.parse(http_response.body)
      temperature_data(weather_data)
    end

    def self.coordinates_weather_call(lat, lon)
      api = "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"

      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)
      weather_data = JSON.parse(http_response.body)
      c = WeatherForecast.new(weather_data["name"])
      c.weather_call
    end

    private

    def temperature_data(weather_data)
      TemperatureData.new(weather_data["name"], weather_data["coord"]["lat"], weather_data["coord"]["lon"], weather_data["main"]["temp"], weather_data["main"]["feels_like"],
                          weather_data["main"]["temp_min"], weather_data["main"]["temp_max"])
    end

    def location_coordinates
      geolocation = "http://api.openweathermap.org/geo/1.0/direct?q=#{@city}&limit=1&appid=#{ENV['OPENWEATHER_API_KEY']}"
      geo_uri = URI(geolocation)
      geo_http = Net::HTTP.get_response(geo_uri)
      geo_json = JSON.parse(geo_http.body)
      if geo_json.empty?
        raise Errors::InvalidCityError, @city
      else
        latitude = geo_json[0]["lat"]
        longitude = geo_json[0]["lon"]
        { lat: latitude, lon: longitude }
      end
    end
  end
end
