# frozen_string_literal: true

# Handles storing forecast data for the application.
class Forecast
  extend Forwardable

  def_delegators :@location, :latitude, :longitude
  def_delegators :@weather, :description, :temperature, :high, :low, :feels_like

  # @param [Hash] args The arguments to create a forecast with.
  # @param option [Location] :location The location data of the forecast.
  # @param option [Weather] :weather The weather data of the forecast.
  def initialize(location:, weather:)
    @location = location
    @weather = weather
  end

  # @return [String] The name of the location.
  def location_name
    @location.name
  end
end
