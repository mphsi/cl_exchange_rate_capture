require "pry"
require 'json'
require 'pg'
require "./env_variables"
require './lib/exchange_rate_capture'

ExchangeRateCapture::Capturist.new.capture(day: Time.now.strftime("%F"))