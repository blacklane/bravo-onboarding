ENV['APP_ENV'] = 'test'

require './myapp.rb' # <-- my sinatra app
require 'rspec'
require 'rack/test'

# describe "Get weather method" do
#   it "should return a JSON" do
#     expect(get_weather).to_json
#   end
# end

RSpec.describe 'My App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "homepage" do
    get '/'
    expect(last_response).to be_ok
  end
end