# frozen_string_literal: true

require 'rails_helper'

require './lib/services/weather_service'
require './lib/connections/geo_location_connection'
require './lib/connections/weather_connection'
require './lib/forecast'
require './lib/location'
require './lib/weather'

# rubocop:disable Metrics/BlockLength
describe WeatherService do
  subject { described_class.new(weather_connection, geo_location_connection) }
  let(:weather_connection) { double(WeatherConnection) }
  let(:geo_location_connection) { double(GeoLocationConnection) }

  describe 'current_weather' do
    let(:street) { '123 Test Dr' }
    let(:city) { 'Testington' }
    let(:state) { 'pa' }
    let(:zip) { '12345' }
    let(:country) { 'US' }
    let(:weather) { double(Weather) }
    let(:location) { double(Location) }
    let(:latitude) { -40.00 }
    let(:longitude) { 40.00 }
    let(:coordinates_response) { 'coordinates_response' }
    let(:current_weather_response) { 'current_weather_response' }

    before do
      allow(geo_location_connection).to receive(:find_coordinates)
        .with(street, city, state, zip, country).and_return(coordinates_response)
      allow(weather_connection).to receive(:current_weather)
        .with(latitude, longitude).and_return(current_weather_response)
      allow(location).to receive(:latitude).and_return(latitude)
      allow(location).to receive(:longitude).and_return(longitude)
      allow(Weather).to receive(:from_current_weather_response).and_return(weather)
      allow(Location).to receive(:from_find_coordinates_response).and_return(location)
    end

    it 'returns the current weather' do
      expect(subject.current_weather(street, city, state, zip)).to be_a(Forecast)
    end
  end
end
# rubocop:enable Metrics/BlockLength
