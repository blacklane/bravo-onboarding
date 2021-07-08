# frozen_string_literal: true

require "json"
require "open-uri"

class GetWeather
  attr_reader :city

  def initialize(city)
    @city = city
  end

  def get_weather
    api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=a64896bb4676c4331e621f1940dc623d"

    weather_serialized = URI.open(api).read

    JSON.parse(weather_serialized)
  end
end
