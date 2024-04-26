# frozen_string_literal: true

require 'rails_helper'

require './lib/connections/geo_location_connection'

# rubocop:disable Metrics/BlockLength
describe GeoLocationConnection do
  subject { described_class.new }

  describe 'find_coordinates' do
    let(:street) { '123 test dr' }
    let(:city) { 'Testington' }
    let(:state) { 'pa' }
    let(:zip) { '12345' }
    let(:country) { 'us' }
    let(:options) do
      {
        query: {
          street: street,
          city: city,
          state: state,
          postalcode: zip,
          countrycodes: country,
          limit: 1,
          normalizeaddress: 1,
          addressdetails: 1,
          key: ENV['GEO_LOCATION_API_KEY'],
          format: 'json'
        },
        headers: {
          accept: 'application/json'
        }
      }
    end

    context 'when the api response is successful' do
      let(:body) { [{ 'address' => { 'postcode' => '12345' } }].to_json }
      let(:response) { instance_double(HTTParty::Response, body: body, code: 200) }

      before do
        allow(described_class).to receive(:get).with('/v1/search/structured', options)
                                               .and_return(response)
      end

      it 'sends a get request to the configured geo location API' do
        expect(
          subject.find_coordinates(street, city, state, zip, country)
        ).to eq(JSON.parse(body))
      end
    end

    context 'when the api response is not successful' do
      let(:response) { instance_double(HTTParty::Response, body: [].to_json, code: 401) }

      before do
        allow(described_class).to receive(:get).with('/v1/search/structured', options)
                                               .and_return(response)
      end

      it 'raises a GeoLocationConnectionError' do
        expect do
          subject.find_coordinates(
            street, city, state, zip, country
          )
        end.to raise_error(GeoLocationConnectionError)
      end
    end

    context 'when the search zipcode does not match the response postalcode' do
      let(:body) { [{ 'address' => { 'postcode' => '65432' } }].to_json }
      let(:response) { instance_double(HTTParty::Response, body: body, code: 200) }

      before do
        allow(described_class).to receive(:get).with('/v1/search/structured', options)
                                               .and_return(response)
      end

      it 'raises a GeoLocationConnectionError' do
        expect do
          subject.find_coordinates(
            street, city, state, zip, country
          )
        end.to raise_error(GeoLocationConnectionError)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
