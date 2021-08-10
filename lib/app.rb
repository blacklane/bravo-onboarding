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

require "i18n"

# locales
I18n.load_path << Dir["#{File.expand_path('./config/locales')}/*.yml"]

# LOCALES = { en: "en", fr: "fr", de: "de" }

before do
  I18n.locale = params[:locale] || "en"
  @locale = I18n.locale
end

set :bind, "0.0.0.0"

use Rack::JSONBodyParser, media: /json/

enable :sessions

get "/" do
  erb :index
end

post "/weather" do
  weather_instance = BlacklaneWeather::WeatherForecast.new(params["city"])
  @weather = weather_instance.weather_call(@locale)
  @json = @weather.to_json
rescue Errors::InvalidCityError => e
  @error_message = e.message
  status(404)
  erb(:error)
end

post "/coordinates" do
  @weather = BlacklaneWeather::WeatherForecast.coordinates_weather_call(params["lat"], params["lng"], @locale)
  @json = @weather.to_json
end
