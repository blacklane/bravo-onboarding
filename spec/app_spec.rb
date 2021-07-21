ENV["APP_ENV"] = "test"

require "./lib/app" # <-- my sinatra app
require "rspec"
require "rack/test"
require "pry-byebug"

RSpec.describe "My App" do
  include Rack::Test::Methods

  let(:berlin_city) { "Berlin" }
  let(:berlin_coordinates) { { lat: 52.5244, lon: 13.4105 } }
  let(:invalid_city) { "Invalid" }

  let(:berlin_instance) { BlacklaneWeather::WeatherForecast.new(berlin_city) }

  let(:invalid_instance) { BlacklaneWeather::WeatherForecast.new(invalid_city) }

  let(:weather_api) {
    "http://api.openweathermap.org/data/2.5/weather?lat=#{berlin_coordinates[:lat]}&lon=#{berlin_coordinates[:lon]}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
  }

  let(:invalid_weather_api) {
    "http://api.openweathermap.org/data/2.5/weather?q=#{invalid_city}&units=metric&appid=#{ENV['OPENWEATHER_API_KEY']}"
  }

  let(:status) { 200 }

  let(:body) {
    { "coord": { "lon": 13.4105, "lat": 52.5244 },
      "weather": [{ "id": 803, "main": "Clouds", "description": "broken clouds", "icon": "04d" }], "base": "stations", "main": { "temp": 27.35, "feels_like": 28.13, "temp_min": 25.14, "temp_max": 28.46, "pressure": 1004, "humidity": 55 }, "visibility": 10_000, "wind": { "speed": 3.58, "deg": 295, "gust": 6.26 }, "clouds": { "all": 75 }, "dt": 1_626_358_147, "sys": { "type": 2, "id": 2_011_538, "country": "DE", "sunrise": 1_626_318_094, "sunset": 1_626_376_960 }, "timezone": 7200, "id": 2_950_159, "name": "Berlin", "cod": 200 }.to_json
  }

  let(:stub) { stub_request(:get, weather_api).to_return(status: status, body: body) }

  let(:coordinates_api) { "http://api.openweathermap.org/geo/1.0/direct?q=#{berlin_city}&limit=1&appid=#{ENV['OPENWEATHER_API_KEY']}" }

  let(:invalid_coordinates_api) { "http://api.openweathermap.org/geo/1.0/direct?q=#{invalid_city}&limit=1&appid=#{ENV['OPENWEATHER_API_KEY']}" }

  let(:coordinates_body) { [{"name":"Berlin","local_names":{"af":"Berlyn","ar":"برلين","ascii":"Berlin","bg":"Берлин","ca":"Berlín","da":"Berlin","de":"Berlin","el":"Βερολίνο","en":"Berlin","eu":"Berlin","fa":"برلین","feature_name":"Berlin","fi":"Berliini","fr":"Berlin","gl":"Berlín","he":"ברלין","hr":"Berlin","hu":"Berlin","id":"Berlin","it":"Berlino","ja":"ベルリン","la":"Berolinum","lt":"Berlynas","mk":"Берлин","nl":"Berlijn","no":"Berlin","pl":"Berlin","pt":"Berlim","ro":"Berlin","ru":"Берлин","sk":"Berlín","sl":"Berlin","sr":"Берлин","th":"เบอร์ลิน","tr":"Berlin","vi":"Berlin"},"lat":52.5244,"lon":13.4105,"country":"DE"}].to_json }

  let(:coordinates_stub) { stub_request(:get, coordinates_api).to_return(status: status, body: coordinates_body) }

  def app
    Sinatra::Application
  end

  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/City/)
  end

  it "displays temperature for berlin" do
    coordinates_stub
    stub
    post "/weather", city: berlin_city
    expect(last_response.status).to eq(200)
    expect(last_response.body).to match(/The current temperature in #{berlin_city}/)
  end

  it "displays the error page with invalid city" do
    stub_request(:get, invalid_coordinates_api).to_return(status: status, body: '[]')
    stub_request(:get, invalid_weather_api).to_return(status: 404, body: '{"cod":"404","message":"city not found"}')
    # binding.pry
    post "/weather", city: invalid_city
    expect(last_response.status).to eq(404)
    expect(last_response.body).to match(/#{invalid_city} is not found/)
  end
end
