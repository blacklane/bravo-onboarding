# frozen_string_literal: true

require "json"
require "open-uri"
require "dotenv"

class GetWeather
  attr_reader :city

  def initialize(city)
    @city = city
  end

  # catch exception and re-raise it

  def get_weather
    api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=#{ENV["OPENWEATHER_API_KEY"]}"
    # api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=a64896bb4676c4331e621f1940dc623d"

    weather_serialized = URI.open(api).read

    JSON.parse(weather_serialized)

    #  better to return an object
    # define our own structure and provide only what is relevant to expose
    # make a new class instance with specific data
  end
end
