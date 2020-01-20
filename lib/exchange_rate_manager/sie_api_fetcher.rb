require "net/http"

module ExchangeRateManager
  class SIEApiFetcher
    attr_reader :errors, :api_token
    SIE_ENDPOINT = "https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF60653/datos"

    def initialize(date_parser: ExchangeRateManager::DateParser.new)
      @parsed_day  = nil
      @errors      = nil
      @date_parser = date_parser
      @api_token   = ENV["API_TOKEN"]
    end

    def fetch_exchange_rate(day:)
      @errors = []

      if (@parsed_day = @date_parser.parse_date(day)).nil?
        @errors << invalid_day_error_message
        return nil
      end

      return get_exchange_rate_from_api(@parsed_day)
    end

    private

    def invalid_day_error_message
      "Invalid day"
    end

    def unexpected_error_calling_api_message
      "SIEApiFetcher: An error ocurred while calling the API"
    end

    def failure_fetching_exchange_rate_message
      "SIEApiFetcher: Could not fetch the exchange rate"
    end

    def unexpected_api_response_structure_message
      "SIEApiFetcher: API response has an unexpected structure"
    end

    def request_uri(start_day_str, end_day_str)
      uri = URI(SIE_ENDPOINT + "/#{start_day_str}/#{end_day_str}")
      uri.query = URI.encode_www_form({token: @api_token})
      return uri
    end

    def get_exchange_rate_from_api(day)
      begin
        res  = Net::HTTP.get_response(request_uri(day, day))
        body = JSON.parse(res.body)

        return exchange_rate_in_response(body)
      rescue
        @errors << unexpected_error_calling_api_message
      end

      return nil
    end

    # API response should come in the following structure:
    # {"bmx" =>
    #   {"series" => [{
    #     "idSerie" => "X",
    #     "titulo" => "Y",
    #     "datos" => [
    #       {"fecha" => "DD/MM/YYYY", "dato" => "18.5432"}
    #     ]}
    #   ]}
    # }
    def exchange_rate_in_response(body)
      value = nil

      begin
        value = body["bmx"]["series"][0]["datos"][0]["dato"].to_f
        @errors << failure_fetching_exchange_rate_message if value.nil?
      rescue
        @errors << unexpected_api_response_structure_message
      end

      return value
    end
  end
end
