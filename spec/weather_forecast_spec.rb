ENV["APP_ENV"] = "test"

require "./lib/blacklane_weather/weather_forecast"
require "./lib/blacklane_weather/temperature_data"
require "rspec"
require "rack/test"

RSpec.describe BlacklaneWeather::WeatherForecast do
  # Use let to reuse Berlin blacklane_weather instance
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
    stub_request(:get, invalid_coordinates_api).to_return(status: status, body: '[]')
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
