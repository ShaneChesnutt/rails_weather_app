# frozen_string_literal: true

# Handles storing location data for the application.
class Location
  attr_reader :latitude, :longitude

  # @param [Hash] args The arguments to create a location with.
  # @param option [Float] :latitude The latitude coordinate.
  # @param option [Float] :longitude The longitude coordinate.
  def initialize(latitude:, longitude:)
    @latitude = latitude
    @longitude = longitude
  end

  # Factory method for creating an instance of Location from the
  # LocationConnection#find_coordinates response.
  #
  # @param response [HTTParty::Response] The find coordinates response object.
  #
  # @return [Location] An instance of Location.
  def self.from_find_coordinates_response(response)
    data = response[0]
    Location.new(
      latitude: data['lat'],
      longitude: data['lon']
    )
  end
end
