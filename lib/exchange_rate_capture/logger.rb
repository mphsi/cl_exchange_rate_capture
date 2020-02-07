module ExchangeRateCapture
  class Logger
    def initialize()
    end

    def log(attempt:, event:, data: nil)
      puts "Attempt (#{attempt}) #{formatted_event(event)} #{formatted_data(data)}"
    end

    def formatted_event(event)
      event.nil? ? "event:missing" : "event:#{event.to_s}"
    end

    def formatted_data(data)
      data.nil? ? "data:none" : "data:#{data.to_s}"
    end
  end
end
