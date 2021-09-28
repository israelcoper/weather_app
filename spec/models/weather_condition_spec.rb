require 'rails_helper'

RSpec.describe WeatherCondition, type: :model do
    describe "validations" do
        it { should validate_presence_of(:address_id) }
        it { should validate_presence_of(:city) }
        it { should validate_presence_of(:region) }
        it { should validate_presence_of(:country) }
        it { should validate_presence_of(:temperature_in_celcius) }
        it { should validate_presence_of(:condition) }
        it { should validate_presence_of(:date_time) }
    end

    describe "associations" do
        it { should belong_to(:address) }
    end
end
