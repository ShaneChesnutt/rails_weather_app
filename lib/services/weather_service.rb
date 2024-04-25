# frozen_string_literal: true

require './lib/location'
require './lib/forecast'
require './lib/weather'

# Service for gather weather data.
class WeatherService
  # @param [WeatherConnection] An instance of a weather connection class.
  # @param [GeoLocationConnection] An instance of a geo location connection
  #   class.
  def initialize(weather_connection, geo_location_connection)
    @weather_api = weather_connection
    @geo_location_api = geo_location_connection
  end

  # Fetches the current weather for the searched US location.
  #
  # @param street [String] The street address.
  # @param city [String] The address city name.
  # @param state [String] The address state name.
  # @param zip [String] The address zipcode.
  #
  # @return [Forecast] The forecast for the target location.
  def current_weather(street, city, state, zip)
    location = find_coordinates(street, city, state, zip)
    weather = get_weather(location)

    Forecast.new(weather: weather, location: location)
  end

  private

  def find_coordinates(street, city, state, zip)
    Location.from_find_coordinates_response(
      @geo_location_api.find_coordinates(street, city, state, zip, 'US')
    )
  end

  def get_weather(location)
    Weather.from_current_weather_response(
      @weather_api.current_weather(location.latitude, location.longitude)
    )
  end
end
