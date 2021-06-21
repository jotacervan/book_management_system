require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Transactions", type: :request do
  let!(:user){ create(:user) }
  let!(:headers){ { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
  let!(:auth_headers){ Devise::JWT::TestHelpers.auth_headers(headers, user) }
  let!(:book1){ create(:book) }
  let!(:book2){ create(:book, name: 'Book 2') }

  describe "GET /api/transactions" do
    it "should return the list of transactions" do
      get "/api/transactions", headers: auth_headers
      expect(response).to have_http_status(:success)
    end
  end
  describe "POST /api/transactions" do
    context "user with balance" do
      it "should create the transaction" do
        post "/api/transactions", params: { transaction: { book_id: book1.id, user_id: user.id, start_date: Date.current, end_date: 5.days.ago } }, headers: auth_headers, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(parsed_body['message']).to eq 'Transaction created successfully'
      end
    end
    context "user without balance" do
      before{ user.update(balance: 0) }
      it "should return no balance error" do
        post "/api/transactions", params: { transaction: { book_id: book1.id, user_id: user.id, start_date: Date.current, end_date: 5.days.ago } }, headers: auth_headers, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:forbidden)
        expect(parsed_body['message']).to eq 'Validation failed: Balance unavailable' 
      end
    end
    context "unavailable book" do
      before{ create(:transaction, book: book1, user: user, start_date: 1.day.ago, end_date: 1.day.from_now) }
      it "should return unavailable book error" do
        post "/api/transactions", params: { transaction: { book_id: book1.id, user_id: user.id, start_date: Date.current, end_date: 5.days.ago } }, headers: auth_headers, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:forbidden)
        expect(parsed_body['message']).to eq 'Validation failed: Book unavailable' 
      end
    end
  end
  describe "PUT /api/transactions/:id" do
    let!(:tr1){ create(:transaction, book: book1, user: user, start_date: 1.day.ago, end_date: 1.day.from_now) }
    it "should return the book successfully" do
      put "/api/transactions/#{tr1.id}", params: { transaction: { returned: true } }, headers: auth_headers, as: :json
      parsed_body = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(parsed_body['message']).to eq 'Book updated successfully' 
    end
  end
  describe "PUT /api/transactions/:id/return" do
    let!(:tr1){ create(:transaction, book: book1, user: user, start_date: 1.day.ago, end_date: 1.day.from_now) }
    it "should return the book successfully" do
      put "/api/transactions/#{tr1.id}/return", headers: auth_headers, as: :json
      parsed_body = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(parsed_body['message']).to eq 'Book returned successfully' 
    end
  end
end
