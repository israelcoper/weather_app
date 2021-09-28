FactoryBot.define do
    factory :weather_condition do
        address

        city { "London" }
        country { "UK" }
        date_time { DateTime.now }
        temperature_in_celcius { 15.0 }
        condition { "COLD" }
    end
end
