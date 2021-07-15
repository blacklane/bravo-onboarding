ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/weather_forecast"
require "./lib/blacklane_weather/temperature_data"
require "rspec"
require "rack/test"

RSpec.describe "The Weather Forecast class" do
  # Use let to reuse Berlin blacklane_weather instance
  let(:berlin_instance) { BlacklaneWeather::WeatherForecast.new("Berlin") }

  it "creates a new instance of GetWeather" do
    expect(berlin_instance).to be_an_instance_of(BlacklaneWeather::WeatherForecast)
  end

  it "has proper attributes" do
    expect(berlin_instance).to have_attributes(city: "Berlin")
  end

  it "raises and argument error when initialized with no argument" do
    expect { BlacklaneWeather::WeatherForecast.new }.to raise_error(ArgumentError)
  end

  context "#weather_call" do
    it "returns an instance of Temperature Data when given a correct city" do
      expect(berlin_instance.weather_call).to be_an_instance_of(BlacklaneWeather::TemperatureData)
    end
  end
end
