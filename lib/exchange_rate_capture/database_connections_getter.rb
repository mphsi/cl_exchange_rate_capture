module ExchangeRateCapture
  class DatabaseConnectionsGetter
    def self.call()
      new().call
    end

    attr_reader :credentials
    def initialize(credentials = [])
      @credentials = if credentials.empty?
        fetch_credentials_from_env_vars
      else
        credentials
      end
    end

    def call
      return credentials.map do |credential|
        ExchangeRateCapture::DBConnection.new(credential)
      end
    end

    private

    def fetch_credentials_from_env_vars
      [{
        "host" => ENV['HOST'],
        "dbname" => ENV['DATBASE'],
        "user" => ENV['USERNAME'],
        "password" => ENV['PASSWORD']
      }]
    end
  end
end
