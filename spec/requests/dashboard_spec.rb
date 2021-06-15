require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /index" do
    context 'logged user' do
      before do
        user = create(:user)
        sign_in user 
      end
      it "returns http success" do
        get "/dashboard/index"
        expect(response).to have_http_status(:success)
      end
    end
    context 'without a logged user' do
      it "returns http redirec" do
        get "/dashboard/index"
        expect(response).to have_http_status(:redirect)
      end
    end
  end

end
