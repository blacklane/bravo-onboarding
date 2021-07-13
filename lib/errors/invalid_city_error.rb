module Errors
  class InvalidCityError < StandardError
    attr_reader :error, :city

    def initialize(error, city)
      @error = error
      @city = city
    end

    def message
      "No city found, enter a valid city name or check spelling"
    end
  end
end