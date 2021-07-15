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
  let(:berlin_instance) { BlacklaneWeather::WeatherForecast.new("Berlin") }

  let(:invalid_instance) { BlacklaneWeather::WeatherForecast.new("incorrect") }

  let(:api) { "http://api.openweathermap.org/data/2.5/weather?q=Berlin&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}" }

  let(:incorrect_api) { "http://api.openweathermap.org/data/2.5/weather?q=incorrect&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}" }

  let(:status) { 200 }

  let(:body) { {"coord":{"lon":13.4105,"lat":52.5244},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":27.35,"feels_like":28.13,"temp_min":25.14,"temp_max":28.46,"pressure":1004,"humidity":55},"visibility":10000,"wind":{"speed":3.58,"deg":295,"gust":6.26},"clouds":{"all":75},"dt":1626358147,"sys":{"type":2,"id":2011538,"country":"DE","sunrise":1626318094,"sunset":1626376960},"timezone":7200,"id":2950159,"name":"Berlin","cod":200}.to_json }

  let(:stub) { stub_request(:get, api).to_return(:status => status, :body => body) }

  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
  end

  it "test stub" do
    stub
  end

  it "returns a Temperature Data object with correct data" do
    stub

    forecast = berlin_instance.weather_call
    expect(forecast.temperature).to eq(27.35)
    expect(forecast.feels_like).to eq(28.13)
    expect(forecast.min_temp).to eq(25.14)
    expect(forecast.max_temp).to eq(28.46)
  end

  it "returns an object when a proper city is given" do
    stub
    berlin_weather_data = berlin_instance.weather_call
    #  expect this to return an object, not specifically a json.
    expect(berlin_weather_data).not_to be_nil
  end

  context "when given Berlin as an argument" do
    it "returns an instance of Temperature Data" do
      stub
      berlin_weather_data = berlin_instance.weather_call
      expect(berlin_weather_data).to be_an_instance_of(BlacklaneWeather::TemperatureData)
    end
  end

  it "raises an error with invalid city" do
    stub_request(:get, incorrect_api).to_raise(Errors::InvalidCityError)

    expect { invalid_instance.weather_call }.to raise_error(Errors::InvalidCityError)
  end
end
