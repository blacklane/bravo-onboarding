ENV["APP_ENV"] = "test"

require "./lib/app"  # <-- your sinatra app
require "capybara"
require "capybara/dsl"
require "capybara-screenshot/rspec"
require "test/unit"
require "spec_helper"
require "i18n"

RSpec.describe "System" do
  include Capybara::DSL
  Capybara.default_driver = :selenium_chrome # <-- use Selenium driver
  include_context "helpers"

  before do
    Capybara.app = Sinatra::Application.new
    Capybara.current_driver = :selenium_chrome
    WebMock.allow_net_connect!(allow_localhost: true)
    #  can enable only local host networks
  end

  context "when visiting home page" do
    it "displays the homepage" do
      visit "/"
      expect(page).to have_content("Current Temperature")
      expect(page).to have_button("city_form")
      expect(page).to have_css(".map")
    end
  end

  context "when inputing a valid city", js: true do
    it "displays the weather information" do
      weather_stub
      visit "/"
      fill_in "city", with: london_city
      click_button("city_form")
      # uncomment below to view screenshot
      # screenshot_and_open_image
      expect(page).to have_content("Weather in London")
    end
  end

  context "when inputting an invalid city", js: true do
    it "displays an error message" do
      visit "/"
      fill_in "city", with: invalid_city
      click_button("city_form")
      expect(page).to have_css("#error_message")
      # uncomment below to view screenshot
      # screenshot_and_open_image
      expect(page).to have_content("#{invalid_city} is not found. Enter a valid city name or check spelling")
    end
  end

  context "when the users locale is en, de, or fr" do
    it "default language is English when no language param given" do
      visit "/"
      expect(page).to have_content("Weather in")
    end
    it "displays a translated weather heading for German", js: true do
      visit "/?locale=de"
      expect(page).to have_content("Wetter in")
    end
    it "displays a translated weather heading for French", js: true do
      visit "/?locale=fr"
      expect(page).to have_content("Météo à")
    end
    # it "redirects to / with English as default is locale is neithe en, fr, nor de", js: true do
    #   visit "/?locale=es"
    #   expect(page).to have_content("Weather in")
    # end
  end
end
