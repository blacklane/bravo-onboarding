# frozen_string_literal: true

require "sinatra"
require "json"
require "open-uri"
require "sinatra/reloader"
require "dotenv"
require "dotenv/load"

require_relative "./blacklane_weather/weather_forecast"
require_relative "./blacklane_weather/temperature_data"
require_relative "./errors/invalid_city_error"

get "/" do
  erb :index
end

post "/" do
  if params[:city]
    weather_instance = BlacklaneWeather::WeatherForecast.new(params["city"])
    @weather = weather_instance.weather_call
    @json = @weather.build_json
    erb(:index)
  elsif params[:lat] && params[:lon]
      weather_instance = BlacklaneWeather::WeatherForecast.coordinates_weather_call(params["lat"], params["lon"])
      @json = weather_instance.build_json
    erb(:index)
  end
  #  rescue any error if not specified
rescue Errors::InvalidCityError => e
  @error_message = e.message
  status(404)
  erb(:error)
end
