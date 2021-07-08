# frozen_string_literal: true

require "sinatra"
require "json"
require "open-uri"
require "sinatra/reloader"

get "/" do
  erb :index
end

post "/weather" do
  # "#{params["city"]}"
  # isolate get_weather in a diff class
  # test the class method
  def get_weather
    @api = "http://api.openweathermap.org/data/2.5/weather?q=#{params['city']}&units=metric&appid=a64896bb4676c4331e621f1940dc623d"
    @weather_serialized = URI.open(@api).read

    @weather = JSON.parse(@weather_serialized)
  end

  begin
    get_weather
    erb :weather
    #  rescue any error if not specified
  rescue
    erb :error
  end
end
