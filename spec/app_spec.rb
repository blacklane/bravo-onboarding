ENV["APP_ENV"] = "test"

require "./lib/app" # <-- my sinatra app
require "rspec"
require "rack/test"

RSpec.describe "My App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Use let to reuse Berlin blacklane_weather instance
  let(:berlin_instance) { WeatherForecast.new("Berlin") }

  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
  end

  it "returns an object when a proper city is given" do
    berlin_weather_data = berlin_instance.weather_call
    #  expect this to return an object, not specifically a json.
    expect(berlin_weather_data).not_to be_nil
  end
  context "when given Berlin as an argument" do
    it "returns a hash" do
      berlin_weather_data = berlin_instance.weather_call
      expect(berlin_weather_data).to be_a(Hash)
    end
  end
  it "raises an error with invalid city" do
    expect { WeatherForecast.new("abcd").weather_call }.to raise_error(Errors::InvalidCityError)
  end
end
