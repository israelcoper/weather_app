class WeatherCondition < ApplicationRecord
    belongs_to :address

    validates :address_id, :city, :region, :country, :temperature_in_celcius, :date_time, :condition, presence: true
end
