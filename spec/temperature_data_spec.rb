ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/temperature_data"
require "rspec"
require "rack/test"

RSpec.describe "The Temperature Data class" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Use let to reuse Berlin blacklane_weather instance
  let(:temperature_instance) { TemperatureData.new(20, 21, 18, 23) }

  it "creates a new instance of GetWeather" do
    expect(temperature_instance).to be_an_instance_of(TemperatureData)
  end
end
