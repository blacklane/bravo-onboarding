# frozen_string_literal: true

require "sinatra"
require "json"
require "open-uri"
require "sinatra/reloader"
require "dotenv"
require 'dotenv/load'

require_relative "./blacklane_weather/weather_forecast"

get "/" do
  erb :index
end

post "/weather" do
  @weather = WeatherForecast.new(params["city"]).weather_call
  erb(:weather)
  #  rescue any error if not specified
rescue OpenURI::HTTPError
  erb(:error)
end
