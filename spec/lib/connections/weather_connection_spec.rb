# frozen_string_literal: true

require 'rails_helper'

require './lib/connections/weather_connection'

# rubocop:disable Metrics/BlockLength
describe WeatherConnection do
  subject { described_class.new }

  describe 'current_weather' do
    let(:body) { { 'description' => 'current_weather' }.to_json }
    let(:latitude) { 31.45 }
    let(:longitude) { -80.32 }
    let(:options) do
      {
        query: {
          lat: latitude,
          lon: longitude,
          appid: ENV['WEATHER_API_KEY'],
          units: 'imperial'
        }
      }
    end

    context 'when the api response is successful' do
      let(:response) { instance_double(HTTParty::Response, body: body, code: 200) }

      before do
        allow(described_class).to receive(:get).with('/data/2.5/weather', options).and_return(response)
      end

      it 'sends a get request to the configured weather API' do
        expect(subject.current_weather(latitude, longitude)).to eq(JSON.parse(body))
      end
    end

    context 'when the api response is not successful' do
      let(:response) { instance_double(HTTParty::Response, body: {}.to_json, code: 401) }

      before do
        allow(described_class).to receive(:get).with('/data/2.5/weather', options).and_return(response)
      end

      it 'sends a get request to the configured weather API' do
        expect do
          subject.current_weather(latitude, longitude)
        end.to raise_error(WeatherConnectionError)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
