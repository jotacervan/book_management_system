require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Books", type: :request do
  let!(:user){ create(:user) }
  let!(:headers){{ 'Accept' => 'application/json', 'Content-Type' => 'application/json' }}
  let!(:auth_headers){ Devise::JWT::TestHelpers.auth_headers(headers, user) }
  let!(:book1){ create(:book, name: 'Book 1') }
  let!(:book2){ create(:book, name: 'Book 2') }
  let!(:book3){ create(:book, name: 'Book 3') }
  describe "GET /api/books" do
    it "returns http success" do
      get "/api/books", headers: auth_headers, as: :json
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(parsed_response['books'].pluck('id')).to eq([book1.id, book2.id, book3.id])
    end
  end
  describe "GET /api/books/transactions" do
    it "return the transaction details of each book" do
    end
  end
end
