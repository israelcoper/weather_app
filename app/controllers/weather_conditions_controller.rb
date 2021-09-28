class WeatherConditionsController < ApplicationController
    def create
        @address = Address.find_or_create_by postcode: params[:postcode]

        if Address.exists? id: @address.id
            # weatherapi request
            api = WeatherApiService.new 'forecast.json', { q: @address.postcode }
            response = api.forecast

            if response[:success] && response[:data].fetch("error", nil).nil?
                # find or create weather conditions cold | warm | hot
                json = { valid: true }
            else
                json = { valid: false, message: response[:data]["error"]["message"] }
            end
        else
            json = { valid: false, message: @address.errors.full_messages[0] }
        end

        render json: json
    end
end
