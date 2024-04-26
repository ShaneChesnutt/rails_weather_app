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
  # @return [Hash] The location data from API request.
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
    data = JSON.parse(response.body)

    raise_geo_location_connection_error(response.to_s) unless success_code?(response.code)
    raise_geo_location_connection_error('Location mismatch error') unless location_match?(data, zip)

    data
  end

  private

  # rubocop:disable Metrics/MethodLength
  def query_params(street, city, state, zip, country)
    {
      street: street,
      city: city,
      state: state,
      postalcode: zip,
      countrycodes: country,
      limit: 1,
      normalizeaddress: 1,
      addressdetails: 1,
      key: @api_key,
      format: 'json'
    }
  end
  # rubocop:enable Metrics/MethodLength

  def success_code?(code)
    code >= 200 && code < 300
  end

  def location_match?(data, zip)
    data[0]['address']['postcode'] == zip
  end

  def raise_geo_location_connection_error(error)
    Rails.logger.error("GeoLocationConnection: #{error}")
    raise GeoLocationConnectionError, 'Unable to find location'
  end
end
