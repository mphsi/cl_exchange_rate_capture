module ExchangeRateCapture
  class PersistedRecordValidator
    def self.call(record)
      new(record).call
    end

    attr_reader :record
    def initialize(record)
      @record = record
    end

    def call
      begin
        id    = record["id"].to_i
        value = record["precio"].to_f
        day   = Date.parse(record["created_at"])

        return (id > 0) && (value > 0) && !(day).nil?
      rescue
        return false
      end
    end
  end
end
