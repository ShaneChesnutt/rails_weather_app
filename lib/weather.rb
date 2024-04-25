# frozen_string_literal: true

# Handles storing weather data for the application.
class Weather
  attr_reader :description, :temperature, :high, :low, :feels_like

  # @param [Hash] args The arguments to create a location with.
  # @param option [String] :description The description of the weather.
  # @param option [Integer] :temperature The current temperature value.
  # @param option [Integer] :high The highest temperature value for today.
  # @param option [Integer] :low The lowest temperature value for today.
  # @param option [Integer] :feel_like The current human perceived temperature.
  def initialize(description:, temperature:, high:, low:, feels_like:)
    @description = description
    @temperature = temperature
    @high = high
    @low = low
    @feels_like = feels_like
  end

  # Factory method for creating an instance of Weather from
  # WeatherConnection#current_weather response.
  #
  # @param response [HTTParty::Response] The current weather response object.
  #
  # @return [Weather] An instance of the Weather class.
  def self.from_current_weather_response(response)
    weather_details = response['weather'][0]
    forecast = response['main']

    Weather.new(
      description: weather_details['description'],
      temperature: forecast['temp'].round,
      high: forecast['temp_max'].round,
      low: forecast['temp_min'].round,
      feels_like: forecast['feels_like'].round
    )
  end
end
