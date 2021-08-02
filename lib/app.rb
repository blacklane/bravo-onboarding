# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "json"
require "open-uri"
require "sinatra/reloader"
require "dotenv"
require "dotenv/load"
require "rack/contrib"

require_relative "./blacklane_weather/weather_forecast"
require_relative "./blacklane_weather/temperature_data"
require_relative "./errors/invalid_city_error"

use Rack::JSONBodyParser, media: /json/

get "/" do
  erb :index
end

post "/weather" do
  # payload = JSON.parse(request.body.read)
  weather_instance = BlacklaneWeather::WeatherForecast.new(params["city"])
  @weather = weather_instance.weather_call
  @json = @weather.to_json
rescue Errors::InvalidCityError => e
  @error_message = e.message
  status(404)
  erb(:error)
end

post "/coordinates" do
  # payload = JSON.parse(request.body.read)
  @weather = BlacklaneWeather::WeatherForecast.coordinates_weather_call(params["lat"], params["lng"])
  @json = @weather.to_json
end
