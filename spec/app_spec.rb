ENV["APP_ENV"] = "test"

require "./lib/myapp" # <-- my sinatra app
require "rspec"
require "rack/test"

RSpec.describe "My App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Use let to reuse Berlin class instance
  let(:berlin_instance) { GetWeather.new("Berlin") }

  it "creates a new instance of GetWeather" do
    expect(berlin_instance).to be_an_instance_of(GetWeather)
  end

  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
  end

  it "returns an object when a proper city is given" do
    berlin_weather_data = berlin_instance.get_weather
    #  expect this to return an object, not specifically a json.
    expect(berlin_weather_data).not_to be_nil
  end

  it "returns a longitude of 13.4105 & a latitude of 52.5244 when given Berlin as an argument" do
    berlin_weather_data = berlin_instance.get_weather
    expect(berlin_weather_data["coord"]["lon"]).to eq(13.4105)
    expect(berlin_weather_data["coord"]["lat"]).to eq(52.5244)
  end

  it "raises an error with invalid city" do
    expect { GetWeather.new("abcd").get_weather }.to raise_error(OpenURI::HTTPError)
  end
end
