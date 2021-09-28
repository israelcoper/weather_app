class WeatherConditionsController < ApplicationController
    def create
        @address = Address.find_or_create_by postcode: params[:postcode]

        if Address.exists? id: @address.id
            # weatherapi request

            json = { valid: true }
        else
            json = { valid: false, message: @address.errors.full_messages }
        end

        render json: json
    end
end
