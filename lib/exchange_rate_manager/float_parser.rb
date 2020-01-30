module ExchangeRateManager
  class FloatParser
    def initialize
    end

    def parse_float(float)
      begin
        float          = Float(float)
        base, decimals = float.to_s.split(".")

        return nil if decimals.size > 4

        float
      rescue
        return nil
      end
    end

    def error_message
      "Invalid float"
    end
  end
end
