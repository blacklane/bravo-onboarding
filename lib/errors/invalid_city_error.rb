# frozen_string_literal: true

module Errors
  class InvalidCityError < StandardError
    attr_reader :city

    def initialize(city)
      @city = city
    end

    def message
      "#{@city} is not found enter a valid city name or check spelling"
    end
  end
end
