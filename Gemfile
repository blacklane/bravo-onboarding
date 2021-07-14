# frozen_string_literal: true

source "https://rubygems.org"

gem "sinatra"

gem "sinatra-contrib"

gem "dotenv-rails"

gem "dotenv"

gem "rack-test"

gem "rake"

%w(rspec rspec-core rspec-expectations rspec-mocks rspec-support).each do |lib|
  gem lib, git: "https://github.com/rspec/#{lib}.git", branch: "main"
end
