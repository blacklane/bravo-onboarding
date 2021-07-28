# frozen_string_literal: true

require_relative "weather_forecast"

module BlacklaneWeather
  class TemperatureData
    attr_reader :city, :lat, :lng, :temperature, :feels_like, :min_temp, :max_temp

    def initialize(city, lat, lng, temperature, feels_like, min_temp, max_temp)
      @city = city
      @lat = lat
      @lng = lng
      @temperature = temperature
      @feels_like = feels_like
      @min_temp = min_temp
      @max_temp = max_temp
    end

    def to_json(*_args)
      weather = {
        city: @city,
        lat: @lat,
        lng: @lng,
        temperature: @temperature,
        feels_like: @feels_like,
        min_temp: @min_temp,
        max_temp: @max_temp
      }
      weather.to_json
    end
  end
end
