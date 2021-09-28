FactoryBot.define do
    factory :address do
        postcode { ["M2 4WU", "W1A 2AB", "E11 3AW", "BN3 3JA"].sample }
    end
end
