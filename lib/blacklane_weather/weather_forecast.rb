# frozen_string_literal: true

require "json"
require "open-uri"
require "./lib/errors/invalid_city_error"
require "net/http"
require_relative "temperature_data"

class WeatherForecast
  attr_reader :city

  def initialize(city)
    @city = city
  end

  def weather_call
    api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
    # api = "http://api.openweathermap.org/data/2.5/weather?q=#{@city}&units=metric&appid=a64896bb4676c4331e621f1940dc623d"

    uri = URI(api)
    weather_serialized = Net::HTTP.get(uri)
    weather_data = JSON.parse(weather_serialized)
    temperature_data(weather_data)
    #  better to return an object
    # define our own structure and provide only what is relevant to expose
    # make a new blacklane_weather instance with specific data
  rescue NoMethodError => e
    raise Errors::InvalidCityError.new(e, @city)
  end

  private

  def temperature_data(weather_data)
    t = TemperatureData.new(weather_data["main"]["temp"], weather_data["main"]["feels_like"],
                            weather_data["main"]["temp_min"], weather_data["main"]["temp_max"])
    t.todays_forecast
  end
end
