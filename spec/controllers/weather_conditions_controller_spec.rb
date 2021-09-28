require 'rails_helper'

RSpec.describe WeatherConditionsController, type: :controller do
    describe "POST weather_conditions#create" do
        describe "with invalid uk postcode" do
            it "returns postcode cant be blank" do
                post :create, params: { postcode: "" }

                json = JSON.parse(response.body)

                expect(response).to have_http_status(:success)
                expect(json).to eq({
                    "valid" => false,
                    "message" => "Postcode can't be blank"
                })
            end

            it "returns postcode not recognised as a UK postcode" do
                post :create, params: { postcode: "DE53PI" }

                json = JSON.parse(response.body)

                expect(response).to have_http_status(:success)
                expect(json).to eq({
                    "valid" => false,
                    "message" => "DE53PI Postcode not recognised as a UK postcode"
                })
            end
        end

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

            it "returns successful json response" do
                stub_request(:get, "http://api.weatherapi.com/v1/forecast.json").
                    with(query: { "key" => ENV["WEATHER_API_KEY"], "q" => "W1A 2AB" }).
                    to_return(status: 200, headers: { content_type: 'application/json' }, body: forecast_response.to_json)

                post :create, params: { postcode: "w1a2ab" }

                json = JSON.parse(response.body)

                date_time = DateTime.parse(forecast_response[:location][:localtime]).strftime('%B %d, %Y')

                expect(response).to have_http_status(:success)
                expect(json).to eq({
                    "valid" => true,
                    "city" => forecast_response[:location][:name],
                    "country" => forecast_response[:location][:country],
                    "date_time" => date_time,
                    "temperature" => forecast_response[:current][:temp_c].to_s,
                    "weather_condition" => "COLD"
                })
            end
        end
    end
end
