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
      api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"

      uri = URI(api)
      http_response = Net::HTTP.get_response(uri)

      if http_response.is_a?(Net::HTTPSuccess)
        weather_data = JSON.parse(http_response.body)
        temperature_data(weather_data)
      else
        raise Errors::InvalidCityError, @city
      end
    end

    private

    def temperature_data(weather_data)
      TemperatureData.new(weather_data["main"]["temp"], weather_data["main"]["feels_like"],
                          weather_data["main"]["temp_min"], weather_data["main"]["temp_max"])
    end
  end
end
