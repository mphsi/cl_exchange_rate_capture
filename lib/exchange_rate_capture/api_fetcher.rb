require "net/http"

module ExchangeRateCapture
  class ApiFetcher
    def self.call(day)
      new(day).call
    end

    # replace with envvar
    SIE_ENDPOINT = "https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF60653/datos"

    attr_reader :day, :api_token
    def initialize(day)
      @day       = day
      @api_token = ENV["API_TOKEN"]
    end

    # SIE API response is expected to be like this:
    # {"bmx" =>
    #   {"series" => [{
    #     "idSerie" => "X",
    #     "titulo" => "Y",
    #     "datos" => [
    #       {"fecha" => "DD/MM/YYYY", "dato" => "18.5432"}
    #     ]}
    #   ]}
    # }
    def call
      begin
        res  = Net::HTTP.get_response(request_uri(day, day))
        body = JSON.parse(res.body)
        return body["bmx"]["series"][0]["datos"][0]["dato"].to_f
      rescue
        return nil
      end
    end

    private

    def request_uri(start_day_str, end_day_str)
      uri = URI(SIE_ENDPOINT + "/#{start_day_str}/#{end_day_str}")
      uri.query = URI.encode_www_form({token: api_token})
      return uri
    end
  end
end