# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
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

post "/weather" do
  payload = JSON.parse(request.body.read)
  puts payload
  if payload["city"]
    weather_instance = BlacklaneWeather::WeatherForecast.new(payload["city"])
    @weather = weather_instance.weather_call
    @json = @weather.to_json
  else
    @weather = BlacklaneWeather::WeatherForecast.coordinates_weather_call(payload["lat"], payload["lng"])
    @json = @weather.to_json
  end
rescue Errors::InvalidCityError => e
  @error_message = e.message
  status(404)
  erb(:error)
end