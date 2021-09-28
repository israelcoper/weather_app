require 'rails_helper'

RSpec.describe HomeController, type: :controller do
    describe "GET home#index" do
        it "renders the index page" do
            get :index
            expect(response).to render_template :index
        end
    end
end
