# frozen_string_literal: true

require "sinatra"
require "json"
require "open-uri"
require "sinatra/reloader"
require_relative "./class/get_weather"
require "dotenv"

get "/" do
  erb :index
end

post "/weather" do
  @weather = GetWeather.new(params["city"]).get_weather
  erb(:weather)
  #  rescue any error if not specified
rescue OpenURI::HTTPError
  erb(:error)
end
