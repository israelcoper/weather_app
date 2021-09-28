class WeatherApiService
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'

    API_KEY = "bca37e59d53c4e2faba12325212809" # TODO: place in yml file

    attr_accessor :resource, :options

    def initialize(resource, options = {})
        @options = { query: { key: API_KEY, q: options.fetch(:q, '') } }
        @resource = resource
    end

    def forecast
        begin
            response = self.class.get("/#{resource}", @options)
            {
                data: JSON.parse(response.body),
                success: true
            }
        rescue SocketError, Net::OpenTimeout => e
            {
                data: { "error" => { "message" => e.to_s } },
                success: false
            }
        end
    end
end
