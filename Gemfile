# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra"

gem "sinatra-contrib"

gem "dotenv"

gem "json"

gem "geocoder"

gem "rack-contrib"

gem "puma"

gem "i18n"

group :development, :test do
  gem "rack-test"

  gem "rake"

  gem "rspec-autotest"

  gem "rubocop"

  # simple cov - https://github.com/simplecov-ruby/simplecov
  # to run - $ open coverage/index.html
  gem "simplecov", require: false

  gem "webmock"

  %w(rspec rspec-core rspec-expectations rspec-mocks rspec-support).each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
  end

  gem "capybara"

  gem "pry-byebug"

  gem "test-unit"

  gem "selenium-webdriver"

  gem "capybara-screenshot"
end
