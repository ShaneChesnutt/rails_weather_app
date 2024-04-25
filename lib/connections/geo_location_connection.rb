# frozen_string_literal: true

require 'httparty'
require './lib/connections/errors/geo_location_connection_error'

# Use for requesting geo location information.
class GeoLocationConnection
  include HTTParty
  base_uri ENV['GEO_LOCATION_API_BASE_URL']

  def initialize
    @api_key = ENV['GEO_LOCATION_API_KEY']
  end

  # Get the location coordinates for the address.
  #
  # @param street [String] The street name of the address.
  # @param city [String] The city name of the address.
  # @param state [String] The state name of the address.
  # @param zip [String] The postalcode of the address.
  # @param country [String] The country code of the address.
  #
  # @return [HTTParty::Response] The location data from API request.
  #
  # @raise [GeoLocationConnectionError] if the geo location API responds with an
  #   unsuccessful response.
  def find_coordinates(street, city, state, zip, country)
    response = self.class.get(
      '/v1/search/structured', {
        query: query_params(street, city, state, zip, country),
        headers: {
          accept: 'application/json'
        }
      }
    )

    raise_geo_location_connection_error(response) unless success_code?(response.code)

    response
  end

  private

  def query_params(street, city, state, zip, country)
    {
      street: street,
      city: city,
      state: state,
      postalcode: zip,
      countrycodes: country,
      key: @api_key,
      format: 'json'
    }
  end

  def success_code?(code)
    code >= 200 && code < 300
  end

  def raise_geo_location_connection_error(response)
    Rails.logger.error("GeoLocationConnection: #{response}")
    raise GeoLocationConnectionError, 'Unable to find location'
  end
end
