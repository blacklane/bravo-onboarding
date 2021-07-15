ENV["APP_ENV"] = "test"

require "./lib/errors/invalid_city_error"
require "rspec"
require "rack/test"

RSpec.describe Errors::InvalidCityError do
  let(:city) { Errors::InvalidCityError.new("invalid") }

  it "displays the correct error message" do
    expect(city.message).to eq("invalid is not found enter a valid city name or check spelling")
  end
end
