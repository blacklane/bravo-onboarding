ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/temperature_data"
require "rspec"
require "rack/test"
require "spec_helper"

RSpec.describe "The Temperature Data class" do
  # Use let to reuse Berlin blacklane_weather instance
  let(:temperature_instance) { BlacklaneWeather::TemperatureData.new(20, 21, 18, 23, 24, 20, 26, "cloudy", "2d") }

  it "creates a new instance of GetWeather" do
    expect(temperature_instance).to be_an_instance_of(BlacklaneWeather::TemperatureData)
  end

  it "raises and argument error when initialized incorrectly" do
    expect { BlacklaneWeather::TemperatureData.new("") }.to raise_error(ArgumentError)
  end
end
