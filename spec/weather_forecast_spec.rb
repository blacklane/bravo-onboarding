ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/weather_forecast"
require "./lib/blacklane_weather/temperature_data"
require "rspec"
require "rack/test"


RSpec.describe BlacklaneWeather::WeatherForecast do
  include_context "helpers"

  before do |e|
    unless e.metadata[:skip_before]
      coordinates_stub
      stub
    end
  end

  it "test stub" do
  end

  it "returns a Temperature Data object with correct data" do
    forecast = berlin_instance.weather_call
    expect(forecast.temperature).to eq(27.35)
    expect(forecast.feels_like).to eq(28.13)
    expect(forecast.min_temp).to eq(25.14)
    expect(forecast.max_temp).to eq(28.46)
  end

  it "returns an object when a proper city is given" do
    berlin_weather_data = berlin_instance.weather_call
    #  expect this to return an object, not specifically a json.
    expect(berlin_weather_data).not_to be_nil
  end

  context "when #weather_call" do
    it "returns an instance of Temperature Data" do
      berlin_weather_data = berlin_instance.weather_call
      expect(berlin_weather_data).to be_an_instance_of(BlacklaneWeather::TemperatureData)
    end
  end

  it "raises an error with invalid city", :skip_before do
    stub_request(:get, invalid_coordinates_api).to_return(status: status, body: "[]")
    stub_request(:get, invalid_weather_api).to_return(status: 404, body: '{"cod":"404","message":"city not found"}')

    expect { invalid_instance.weather_call }.to raise_error(Errors::InvalidCityError)
  end

  it "creates a new instance of GetWeather" do
    expect(berlin_instance).to be_an_instance_of(BlacklaneWeather::WeatherForecast)
  end

  it "has proper attributes" do
    expect(berlin_instance).to have_attributes(city: "Berlin")
  end

  it "raises and argument error when initialized with no argument" do
    expect { BlacklaneWeather::WeatherForecast.new }.to raise_error(ArgumentError)
  end
end
