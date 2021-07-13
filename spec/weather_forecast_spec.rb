ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/weather_forecast"
require "rspec"
require "rack/test"

RSpec.describe "The Weather Forecast class" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Use let to reuse Berlin blacklane_weather instance
  let(:berlin_instance) { WeatherForecast.new("Berlin") }

  it "creates a new instance of GetWeather" do
    expect(berlin_instance).to be_an_instance_of(WeatherForecast)
  end
end
