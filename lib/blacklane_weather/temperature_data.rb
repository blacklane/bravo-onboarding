# frozen_string_literal: true

require_relative "weather_forecast"

module BlacklaneWeather
  class TemperatureData
    attr_reader :temperature, :feels_like, :min_temp, :max_temp

    def initialize(temperature, feels_like, min_temp, max_temp)
      @temperature = temperature
      @feels_like = feels_like
      @min_temp = min_temp
      @max_temp = max_temp
    end
  end
end
