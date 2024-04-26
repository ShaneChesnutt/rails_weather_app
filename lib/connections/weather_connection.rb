# frozen_string_literal: true

require 'httparty'
require './lib/connections/errors/weather_connection_error'

# Use for requesting weather information.
class WeatherConnection
  include HTTParty
  base_uri ENV['WEATHER_API_BASE_URL']

  def initialize
    @api_key = ENV['WEATHER_API_KEY']
  end

  # Find the current weather base on the location coordinates.
  #
  # @param latitude [Float] The location latitude coordinate.
  # @param longitude [Float] The location longitude coordinate.
  #
  # @return [Hash] The current weather information from the API request.
  #
  # @raise [WeatherConnectionError] if the weather API responds with an
  #   unsuccessful response.
  def current_weather(latitude, longitude)
    response = self.class.get('/data/2.5/weather', {
                                query: {
                                  lat: latitude,
                                  lon: longitude,
                                  appid: @api_key,
                                  units: 'imperial'
                                }
                              })
    data = JSON.parse(response.body)

    raise_weather_connection_error(response) unless success_code?(response.code)

    data
  end

  private

  def success_code?(code)
    code >= 200 && code < 300
  end

  def raise_weather_connection_error(response)
    Rails.logger.error("WeatherConnectionError: #{response}")
    raise WeatherConnectionError, 'Unable to find current weather for location'
  end
end
