class WeatherConditionsController < ApplicationController
    def create
        postcode = UKPostcode.parse(params[:postcode]).to_s # normalise postcode
        @address = Address.find_or_create_by postcode: postcode

        if Address.exists?(id: @address.id)
            # weatherapi request
            api = WeatherApiService.new 'forecast.json', { q: @address.postcode }
            response = api.forecast
            data = response[:data]
            success = response[:success]
            weather_condition = response[:weather_condition]

            if success && weather_condition.present? && data.fetch("error", nil).nil?
                # find or create weather conditions cold | warm | hot
                location = data["location"]
                current = data["current"]

                weather_condition_params = {
                    city: location["name"],
                    region: location["region"],
                    country: location["country"],
                    date_time: location["localtime"],
                    temperature_in_celcius: current["temp_c"]
                }

                @weather_condition = @address.weather_conditions.find_by condition: weather_condition

                if @weather_condition.present?
                    # update if existing
                    @weather_condition.update_attributes weather_condition_params
                else
                    # create new record
                    @weather_condition = @address.weather_conditions.find_or_create_by weather_condition_params.merge({ condition: weather_condition })
                end

                # successful request
                json = {
                    valid: true,
                    city: @weather_condition.city,
                    country: @weather_condition.country,
                    date_time: @weather_condition.date_time.strftime('%B %d, %Y'),
                    temperature: @weather_condition.temperature_in_celcius,
                    weather_condition: @weather_condition.condition
                }
            else
                # weatherapi error
                json = { valid: false, message: data['error']['message'] }
            end
        else
            # invalid uk postcode
            json = { valid: false, message: "#{@address.postcode} #{@address.errors.full_messages[0]}" }
        end

        render json: json
    end
end
