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
      begin
        JSON.parse(ENV["DB_CREDENTIALS_ARRAY"]).map do |creds|
          {
            "host" => creds["host"],
            "dbname" => creds["database"],
            "user" => creds["username"],
            "password" => creds["password"]
          }
        end
      rescue
        return []
      end
    end
  end
end
