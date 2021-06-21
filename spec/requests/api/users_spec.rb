require 'rails_helper'
require 'devise/jwt/test_helpers'

RSpec.describe "Users", type: :request do
  let!(:user){ create(:user) }
  describe "GET /api/users" do
    context 'logged user' do 
      it "returns http success" do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        get "/api/users", headers: auth_headers
        expect(response).to have_http_status(:success)
      end
    end
  end
  describe "POST /users/sign_in" do
    context 'valid user' do
      it "should return the authorization token" do
        post "/users/sign_in", params: { 'user': { email: 'reader_boy@email.com.br', password: '123456' }}, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(response.headers['Authorization']).to be_truthy
        expect(parsed_body['email']).to eq 'reader_boy@email.com.br'
        expect(parsed_body['name']).to eq 'Reader Boy'
      end
    end
    context 'invalid email' do
      it "should return a json error" do
        post "/users/sign_in", params: { 'user': { email: 'invalid@email.com.br', password: '123456' } }, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body['error']).to eq 'Invalid Email or password.'
      end
    end
    context 'invalid password' do
      it "should return a json error" do
        post "/users/sign_in", params: { 'user': { email: 'reader_boy@email.com.br', password: '1234568' } }, as: :json
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(parsed_body['error']).to eq 'Invalid Email or password.'
      end
    end
  end
  describe "GET /api/users/:user_id" do
    context 'without active transaction' do
      it 'should return de users details' do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        get "/api/users/#{user.id}", headers: auth_headers
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:success) 
        expect(parsed_body['user']).to eq({'name' => 'Reader Boy', 'email' => 'reader_boy@email.com.br', 'balance' => 50, 'account_number' => user.account_number})
        expect(parsed_body['current_book']).to be nil
      end   
    end
    context 'with active transaction' do
      before do 
        book = create(:book, name: 'Book 1')
        create(:transaction, book: book, user: user, start_date: 2.days.ago, end_date: 2.days.from_now)
      end
      it 'should return the book with the return date' do
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
        get "/api/users/#{user.id}", headers: auth_headers
        parsed_body = JSON.parse(response.body)
        expect(response).to have_http_status(:success) 
        expect(parsed_body['user']).to eq({'name' => 'Reader Boy', 'email' => 'reader_boy@email.com.br', 'balance' => 50, 'account_number' => user.account_number})
        expect(parsed_body['current_books']).to eq([{ 'name' => 'Book 1', 'return_date' => 2.days.from_now.strftime('%Y-%m-%d')}])
      end
    end
  end
end
