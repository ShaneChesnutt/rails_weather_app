# frozen_string_literal: true

require 'rails_helper'

require './lib/services/weather_service'

# rubocop:disable Metrics/BlockLength
describe ForecastController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'POST #search' do
    let(:weatherService) { double(WeatherService, :current_weather) }
    let(:forecast) { double(Forecast) }
    let(:params) do
      {
        address: {
          street: 'Test 123 RD',
          city: 'Testington',
          state: 'Pennsylvania',
          zip: '12345'
        }
      }
    end

    context 'when valid parameters are passed in' do
      context 'when the zipcode is not found in the cache' do
        before do
          allow_any_instance_of(WeatherService).to receive(:current_weather)
            .and_return(forecast)
          post :search, params: params
        end

        it 'renders the search template' do
          expect(response.body).to render_template('index')
        end
      end

      context 'when the zipcode is found in the cache' do
        let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
        let(:cache) { Rails.cache }

        before do
          allow(Rails).to receive(:cache).and_return(memory_store)
          memory_store.write("#{params[:address][:zip]}/forecast", 'forecast')
          post :search, params: params
        end

        it 'renders the search template' do
          expect(response.body).to render_template('index')
        end
      end
    end

    context 'when invalid parameters are passed in' do
      let(:invalid_params) do
        {
          address: {
            invalid: 'I am error'
          }
        }
      end

      before do
        allow_any_instance_of(WeatherService).to receive(:current_weather)
          .and_return(forecast)
        post :search, params: invalid_params.merge(params)
      end

      it 'renders the index template' do
        expect(response.body).to render_template('index')
      end
    end

    context 'when no parameters are passed in' do
      before do
        post :search
      end

      it 'renders the search template' do
        expect(response.body).to render_template('index')
      end
    end

    context 'when current weather raises a GeoLocationConnectionError exception' do
      before do
        allow_any_instance_of(WeatherService).to receive(:current_weather)
          .and_raise(GeoLocationConnectionError, 'Location not found')
        post :search, params: params
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Location not found')
      end

      it 'redirects to the application root' do
        expect(response).to redirect_to('/')
      end
    end

    context 'when current weather raises a WeatherConnectionError exception' do
      before do
        allow_any_instance_of(WeatherService).to receive(:current_weather)
          .and_raise(WeatherConnectionError, 'Weather not found')
        post :search, params: params
      end

      it 'sets the flash error message' do
        expect(flash[:error]).to eq('Weather not found')
      end

      it 'redirects to the application root' do
        expect(response).to redirect_to('/')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
