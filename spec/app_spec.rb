ENV["APP_ENV"] = "test"

require "./lib/myapp" # <-- my sinatra app
require "rspec"
require "rack/test"

# describe "Get weather method" do
#   it "should return a JSON" do
#     expect(get_weather).to_json
#   end
# end

RSpec.describe "My App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "homepage" do
    get "/"
    expect(last_response).to be_ok
  end

  it "Get weather" do
    @city = GetWeather.new("Berlin")
    @weather_data = @city.get_weather
    #  expect this to return a json
    expect(@weather_data).not_to be_nil
  end
  #  test a specific value that the json could return
  # given the right json is it giving the right value, if wrong, an error
  #
end
