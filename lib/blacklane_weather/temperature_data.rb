# frozen_string_literal: true

require_relative "weather_forecast"

module BlacklaneWeather
  class TemperatureData
    attr_reader :city, :lat, :lon, :temperature, :feels_like, :min_temp, :max_temp

    def initialize(city, lat, lon, temperature, feels_like, min_temp, max_temp)
      @city = city
      @lat = lat
      @lon = lon
      @temperature = temperature
      @feels_like = feels_like
      @min_temp = min_temp
      @max_temp = max_temp
    end

    def build_json
      weather = {
        city: @city,
        lat: @lat,
        lon: @lon,
        temperature: @temperature,
        feels_like: @feels_like,
        min_temp: @min_temp,
        max_temp: @max_temp
      }
      weather.to_json
    end
  end
end
