# frozen_string_literal: true

require 'rails_helper'

require './lib/forecast'
require './lib/weather'
require './lib/location'

# rubocop:disable Metrics/BlockLength
describe Forecast do
  subject { described_class.new(weather: weather, location: location) }
  let(:weather) { double(Weather) }
  let(:location) { double(Location) }

  describe '#latitude' do
    let(:latitude) { 40.00 }

    before do
      allow(location).to receive(:latitude).and_return(latitude)
    end

    it 'returns the location latitude value' do
      expect(subject.latitude).to eq(latitude)
    end
  end

  describe '#longitude' do
    let(:longitude) { 40.00 }

    before do
      allow(location).to receive(:longitude).and_return(longitude)
    end

    it 'returns the location longitude value' do
      expect(subject.longitude).to eq(longitude)
    end
  end

  describe '#description' do
    let(:description) { 'Sunny' }

    before do
      allow(weather).to receive(:description).and_return(description)
    end

    it 'returns the weather description value' do
      expect(subject.description).to eq(description)
    end
  end

  describe '#temperature' do
    let(:temperature) { 65 }

    before do
      allow(weather).to receive(:temperature).and_return(temperature)
    end

    it 'returns the weather temperature value' do
      expect(subject.temperature).to eq(temperature)
    end
  end

  describe '#high' do
    let(:high) { 80 }

    before do
      allow(weather).to receive(:high).and_return(high)
    end

    it 'returns the weather high value' do
      expect(subject.high).to eq(high)
    end
  end

  describe '#low' do
    let(:low) { 50 }

    before do
      allow(weather).to receive(:low).and_return(low)
    end

    it 'returns the weather low value' do
      expect(subject.low).to eq(low)
    end
  end

  describe '#feels_like' do
    let(:feels_like) { 67 }

    before do
      allow(weather).to receive(:feels_like).and_return(feels_like)
    end

    it 'returns the weather feels_like value' do
      expect(subject.feels_like).to eq(feels_like)
    end
  end
end
# rubocop:enable Metrics/BlockLength
