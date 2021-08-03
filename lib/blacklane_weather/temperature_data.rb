# frozen_string_literal: true

require_relative "weather_forecast"

module BlacklaneWeather
  class TemperatureData
    attr_reader :city, :lat, :lng, :temperature, :feels_like, :min_temp, :max_temp, :description, :icon

    def initialize(city, lat, lng, temperature, feels_like, min_temp, max_temp, description, icon)
      @city = city
      @lat = lat
      @lng = lng
      @temperature = temperature
      @feels_like = feels_like
      @min_temp = min_temp
      @max_temp = max_temp
      @description = description
      @icon = icon
    end

    def to_json(*_args)
      weather = {
        city: @city,
        lat: @lat,
        lng: @lng,
        temperature: @temperature,
        feels_like: @feels_like,
        min_temp: @min_temp,
        max_temp: @max_temp,
        description: @description,
        icon: @icon
      }
      weather.to_json
    end
  end
end
