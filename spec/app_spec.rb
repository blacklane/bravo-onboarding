ENV["APP_ENV"] = "test"

require "./lib/app" # <-- my sinatra app
require "rspec"
require "rack/test"

RSpec.describe "My App" do
  include Rack::Test::Methods

  let(:berlin_city) { "Berlin" }
  let(:invalid_city) { "Invalid" }

  let(:berlin_instance) { BlacklaneWeather::WeatherForecast.new(berlin_city) }

  let(:invalid_instance) { BlacklaneWeather::WeatherForecast.new(invalid_city) }

  let(:api) {
    "http://api.openweathermap.org/data/2.5/weather?q=#{berlin_city}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
  }

  let(:incorrect_api) {
    "http://api.openweathermap.org/data/2.5/weather?q=#{invalid_city}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
  }

  let(:status) { 200 }

  let(:body) {
    { "coord": { "lon": 13.4105, "lat": 52.5244 },
      "weather": [{ "id": 803, "main": "Clouds", "description": "broken clouds", "icon": "04d" }], "base": "stations", "main": { "temp": 27.35, "feels_like": 28.13, "temp_min": 25.14, "temp_max": 28.46, "pressure": 1004, "humidity": 55 }, "visibility": 10_000, "wind": { "speed": 3.58, "deg": 295, "gust": 6.26 }, "clouds": { "all": 75 }, "dt": 1_626_358_147, "sys": { "type": 2, "id": 2_011_538, "country": "DE", "sunrise": 1_626_318_094, "sunset": 1_626_376_960 }, "timezone": 7200, "id": 2_950_159, "name": "Berlin", "cod": 200 }.to_json
  }

  let(:stub) { stub_request(:get, api).to_return(status: status, body: body) }

  def app
    Sinatra::Application
  end


  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to include("City")
  end

  it "displays temperature for berlin" do
    stub
    post "/weather", city: "Berlin"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Berlin")
  end

  it "displays the error page with invalid city" do
    stub_request(:get, incorrect_api).to_return(status: 404, body: '{"cod":"404","message":"city not found"}' )
    post "/error", city: "Invalid"
    expect(last_response.status).to eq(404)
  end
end

