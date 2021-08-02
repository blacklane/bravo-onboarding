# frozen_string_literal: true

# require_relative './myapp'
require "./lib/app"

run Sinatra::Application

Capybara.app = "./lib/app"
