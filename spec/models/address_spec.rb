require 'rails_helper'

RSpec.describe Address, type: :model do
    let!(:address) { build(:address, { postcode: "" }) }

    describe "validations" do
        it "validates postcode" do
            address.save
            expect(address.errors.full_messages).to eq ["Postcode can't be blank", "Postcode not recognised as a UK postcode"]

            address.postcode = Faker::Address.postcode
            address.save
            expect(address.errors.full_messages).to eq ["Postcode not recognised as a UK postcode"]

            address.postcode = "w1a2ab"
            expect(address.save).to eq true
            expect(address.postcode).to eq "W1A 2AB"
        end
    end

    describe "associations" do
        it { should have_many(:weather_conditions) }
    end

    describe "instance methods" do
        describe "postcode setter" do
            it "normalise the postcode" do
                address.postcode = "w1a2ab"
                expect(address.postcode).to eq "W1A 2AB"
            end
        end
    end
end
