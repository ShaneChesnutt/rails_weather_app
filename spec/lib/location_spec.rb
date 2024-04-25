# frozen_string_literal: true

require 'rails_helper'

require './lib/location'

describe Location do
  describe '.from_find_coordinates_response' do
    let(:coordinates_response) do
      [{ 'lat' => 40.65563, 'lon' => -54.23553, 'display_name' => '123 Test dr, Testington, PA, 12345, US' }]
    end

    it 'returns a new location object' do
      expect(
        described_class.from_find_coordinates_response(coordinates_response)
      ).to be_a Location
    end
  end
end
