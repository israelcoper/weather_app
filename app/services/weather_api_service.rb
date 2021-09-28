class WeatherApiService
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'

    API_KEY = CONFIG["WEATHER_API_KEY"]

    CONDITIONS = { cold: "COLD", warm: "WARM", hot: "HOT" }

    attr_accessor :resource, :options, :weather_condition

    def initialize(resource, options = {})
        @options = { query: { key: API_KEY, q: options.fetch(:q, '') } }
        @resource = resource
        @weather_condition = ""
    end

    def forecast
        begin
            response = self.class.get("/#{resource}", @options)
            json = JSON.parse(response.body)

            set_weather_condition(json["current"]["temp_c"]) if json.fetch("error", nil).nil?

            {
                data: json,
                weather_condition: weather_condition,
                success: true
            }
        rescue SocketError, Net::OpenTimeout => e
            {
                data: { "error" => { "message" => e.to_s } },
                weather_condition: weather_condition,
                success: false
            }
        end
    end

    protected

    def set_weather_condition(temperature = 0)
        self.weather_condition = if temperature < 20
                CONDITIONS[:cold]
            elsif temperature >= 20 && temperature <= 25
                CONDITIONS[:warm]
            else
                CONDITIONS[:hot]
            end
    end
end
