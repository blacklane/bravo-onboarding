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
      api = "http://api.openweathermap.org/data/2.5/weather?lat=#{coordinates[:lat]}&lon=#{coordinates[:lng]}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
      weather_data = parse_api(api)
      temperature_data(weather_data)
    end

    def self.coordinates_weather_call(lat, lng)
      api = "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lng}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)
      weather_data = JSON.parse(http_response.body)
      c = WeatherForecast.new(weather_data["name"])
      c.temperature_data(weather_data)
    end

    def parse_api(api)
      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)
      JSON.parse(http_response.body)
    end

    def temperature_data(weather_data)
      TemperatureData.new(weather_data["name"], \
                          weather_data["coord"]["lat"], \
                          weather_data["coord"]["lon"], \
                          weather_data["main"]["temp"], \
                          weather_data["main"]["feels_like"], \
                          weather_data["main"]["temp_min"], \
                          weather_data["main"]["temp_max"], \
                          weather_data["weather"][0]["description"], \
                          weather_data["weather"][0]["icon"])
    end

    private

    def location_coordinates
      geolocation = "http://api.openweathermap.org/geo/1.0/direct?q=#{@city}&limit=1&appid=#{ENV['OPENWEATHER_API_KEY']}"
      geo_json = parse_api(geolocation)
      raise Errors::InvalidCityError, @city if geo_json.empty?
      latitude = geo_json[0]["lat"]
      longitude = geo_json[0]["lon"]
      { lat: latitude, lng: longitude }
    end
  end
end
