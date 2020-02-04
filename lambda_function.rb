require 'json'
require 'pg'
require './lib/exchange_rate_capture'

def lambda_handler(event:, context:)
  day = current_day
  puts "day: #{day}"

  new_capturist.capture(day: day)

  {
    statusCode: 200,
    body: lambda_handler_message(day)
  }
end

def current_day
  Time.now.strftime("%F")
end

def new_capturist
  ExchangeRateCapture::Capturist.new
end

def lambda_handler_message(day)
  "An attempt for capturing the Exchange Rate for #{day} as made"
end