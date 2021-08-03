ENV["APP_ENV"] = "test"

require "./lib/app" # <-- my sinatra app
require "rspec"
require "rack/test"
require "pry-byebug"
require "capybara"
require "capybara/dsl"
require "spec_helper"

RSpec.describe "My App" do
  include Rack::Test::Methods
  include_context "helpers"

  def app
    Sinatra::Application
  end

  it "displays a homepage" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Enter a city/)
  end

  it "displays temperature for berlin" do
    coordinates_stub
    stub
    post "/weather", city: berlin_city
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("{\"city\":\"Berlin\"")
  end

  it "displays the error page with invalid city" do
    stub_request(:get, invalid_coordinates_api).to_return(status: status, body: "[]")
    stub_request(:get, invalid_weather_api).to_return(status: 404, body: '{"cod":"404","message":"city not found"}')
    post "/weather", city: invalid_city
    expect(last_response.status).to eq(404)
    expect(last_response.body).to match(/#{invalid_city} is not found/)
  end

  it "displays temperature with valid coordinates" do
    stub
    post "/coordinates", { lat: 52.5244, lng: 13.4105 }
    expect(last_response.status).to eq(200)
  end
end
