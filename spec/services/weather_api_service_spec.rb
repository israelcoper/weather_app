require 'rails_helper'

RSpec.describe WeatherApiService, type: :model do
    let!(:valid_api) { WeatherApiService.new("forecast.json", { q: "W1A 2AB" }) }
    let!(:invalid_api) { WeatherApiService.new("forecast.json", { q: "de53pi" }) }

    describe "#forecast" do
        describe "with valid uk postcode" do
            forecast_response = {
                location: {
                    name: "London",
                    region: "London",
                    country: "UK",
                    localtime: "2021-09-28 13:30"
                },
                current: {
                    temp_c: 15.0
                }
            }

            it "returns uk weather forecast as json" do
                stub_request(:get, "http://api.weatherapi.com/v1/forecast.json").
                    with(query: { "key" => ENV["WEATHER_API_KEY"], "q" => "W1A 2AB" }).
                    to_return(status: 200, headers: { content_type: 'application/json' }, body: forecast_response.to_json)

                forecast = valid_api.forecast

                expect(forecast[:data].to_json).to eq forecast_response.to_json
                expect(forecast[:success]).to eq true
                expect(forecast[:weather_condition]).to eq "COLD"
            end
        end
        
        describe "with invalid uk postcode" do
            forecast_response = {
                error: {
                    code: "de53pi",
                    message: "No matching location found."
                }
            }

            it "returns no matching location found message" do
                stub_request(:get, "http://api.weatherapi.com/v1/forecast.json").
                    with(query: { "key" => ENV["WEATHER_API_KEY"], "q" => "de53pi" }).
                    to_return(status: 200, headers: { content_type: 'application/json' }, body: forecast_response.to_json)

                forecast = invalid_api.forecast

                expect(forecast[:data].to_json).to eq forecast_response.to_json
                expect(forecast[:success]).to eq true
                expect(forecast[:weather_condition]).to eq ""
            end
        end
    end

    describe "#set_weather_condition" do
        it "assign the correct weather condition based on the temperature given" do
            valid_api.set_weather_condition(15)
            expect(valid_api.weather_condition).to eq "COLD"
            
            valid_api.set_weather_condition(20)
            expect(valid_api.weather_condition).to eq "WARM"
            
            valid_api.set_weather_condition(26)
            expect(valid_api.weather_condition).to eq "HOT"
        end
    end
end
