# frozen_string_literal: true

require './lib/services/weather_service'
require './lib/connections/weather_connection'
require './lib/connections/geo_location_connection'

# Handles requests to the forecast endpoints
class ForecastController < ApplicationController
  def index; end

  def search
    perform_search if params[:address]
    render 'index'
  rescue GeoLocationConnectionError, WeatherConnectionError => e
    process_error(e)
  end

  private

  def perform_search
    address = search_params
    @cache = true
    @location_name = "#{address[:city]}, #{address[:state]}, #{address[:zip]}"
    @forecast = Rails.cache.fetch("#{address[:zip]}/forecast", expires_in: 30.minutes) do
      logger.info("Cache miss for zip: #{address[:zip]}")
      @cache = false
      search_current_weather(address[:street], address[:city], address[:state], address[:zip])
    end
  end

  def search_current_weather(street, city, state, zip)
    weather_service = WeatherService.new(WeatherConnection.new, GeoLocationConnection.new)
    weather_service.current_weather(street, city, state, zip)
  end

  def process_error(error)
    logger.error(error)
    flash[:error] = error.message
    redirect_to action: 'index'
  end

  def search_params
    params.require(:address).permit(:street, :city, :state, :zip)
  end
end
