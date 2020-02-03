module ExchangeRateCapture
  class ValueValidator
    def self.call(value)
      new(value).call
    end

    MAX_ALLOWED_DECIMALS = 4

    attr_reader :value
    def initialize(value)
      @value = value
    end

    def call
      begin
        float          = Float(value)
        base, decimals = float.to_s.split(".")

        return decimals.size <= MAX_ALLOWED_DECIMALS
      rescue
        return false
      end
    end
  end
end
