# frozen_string_literal: true

Rails.application.routes.draw do
  post 'forecast/search', 'forecast#search'
  get 'forecast/search', 'forecast#index'

  root 'forecast#index'
end
