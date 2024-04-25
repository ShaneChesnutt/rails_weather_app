# frozen_string_literal: true

require 'rails_helper'

require './lib/weather'

describe Weather do
  describe '.from_current_weather_response' do
    let(:current_weather_response) do
      { 'weather' => [{ 'description' => 'scattered clouds' }],
        'main' => { 'temp' => 60.55, 'feels_like' => 57.99, 'temp_min' => 58.82, 'temp_max' => 62.11 } }
    end

    it 'returns a new weather object' do
      expect(described_class.from_current_weather_response(current_weather_response)).to be_a Weather
    end
  end
end
