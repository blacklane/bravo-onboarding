# frozen_string_literal: true

require "sinatra"
require "json"
require "open-uri"
require "sinatra/reloader"
require "dotenv"
require 'dotenv/load'

require_relative "./blacklane_weather/weather_forecast"
require_relative './errors/invalid_city_error'

get "/" do
  erb :index
end

post "/weather" do
  begin
    @weather = WeatherForecast.new(params["city"]).weather_call
    erb(:weather)
    #  rescue any error if not specified
  rescue
    erb(:error)
  end
end
