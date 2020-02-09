require "securerandom"

module ExchangeRateCapture
  class Capturist
    attr_reader :logger, :attempt_id
    def initialize(logger: Logger.new)
      @logger     = logger
      @attempt_id = SecureRandom.hex(10)
      @errors     = []
    end

    def capture(day: nil)
      log_attempt_start(day)

      check_if_day_is_valid(day)
      value = ask_fetcher_for_value(day)
      check_if_value_is_valid(value)
      results = ask_inserter_for_inserting_value_in_day(value, day)
      check_if_values_were_persisted(results)

      log_attempt_end(day)
    end

    private

    def log_attempt_start(day)
      return nil unless @errors.empty?

      log_event(event: "starting attempt for day #{day}")
    end

    def check_if_day_is_valid(day)
      return nil unless @errors.empty?

      if DayValidator.call(day) == false
        message = "day #{day} is considered not valid"
        append_error(message)
      else
        message = "day #{day} is considered valid"
      end

      log_event(event: message)
    end

    def ask_fetcher_for_value(day)
      return nil unless @errors.empty?

      if (value = ApiFetcher.call(day)).nil?
        message = "value was not fetched for day #{day}"
        append_error(message)
      else
        message = "value #{value} was fetched for day #{day}"
      end

      log_event(event: message)
      return value
    end

    def check_if_value_is_valid(value)
      return nil unless @errors.empty?

      if ValueValidator.call(value) == false
        message = "value #{value} is considered not valid"
        append_error(message)
      else
        message = "value #{value} is considered valid"
      end

      log_event(event: message)
    end

    def ask_inserter_for_inserting_value_in_day(value, day)
      return nil unless @errors.empty?

      if (records = Inserter.call(value, day)).empty?
        log_messages = [
          "no attempt for inserting value #{value} for day #{day} was made"
        ]
      else
        log_messages = records.map do |record|
          "an attempt for inserting value #{value} for day #{day} was made " \
          "@ database #{record["database_name"]}"
        end
      end

      log_messages.each{ |message| log_event(event: message) }
      return records
    end

    def check_if_values_were_persisted(results)
      return nil unless @errors.empty?

      results.each do |result|
        if PersistedRecordValidator.call(result["database_record"]) == false
          message = "record was not persisted @ database #{result["database_name"]}"
          append_error(message)
        else
          message = "record was persisted @ database #{result["database_name"]}"
        end
        log_event(event: message, data: result["database_record"].to_json)
      end
    end

    def log_attempt_end(day)
      return nil unless @errors.empty?

      log_event(event: "ending attempt for day #{day}")
    end

    def append_error(message)
      @errors << message
    end

    def log_event(event:, data: nil)
      logger.log(attempt: attempt_id, event: event, data: data)
    end
  end
end
