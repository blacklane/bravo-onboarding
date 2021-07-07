require 'sinatra'
require 'json'
require 'open-uri'
require "sinatra/reloader"

get '/' do
  erb :index
end

post '/weather' do
  # "#{params["city"]}"
  @api = "http://api.openweathermap.org/data/2.5/weather?q=#{params["city"]}&units=metric&appid=a64896bb4676c4331e621f1940dc623d
"
  @weather_serialized = URI.open(@api).read

  @weather = JSON.parse(@weather_serialized)

  erb :weather
end
