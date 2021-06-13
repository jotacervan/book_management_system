require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'create user' do
    context 'with a valid record' do
      let!(:valid_user){ User.create(name: 'Reader Boy', email: 'test@email.com.br', password: '123456', password_confirmation: '123456') }
      it 'should create a user successfully' do
        expect(User.count).to eq 1
        expect(valid_user.email).to eq 'test@email.com.br'
      end
      it 'should start with a balance of 50' do
        expect(valid_user.balance).to eq 50  
      end
      it 'should generate a account number on create' do
        expect(valid_user.account_number).to_not be nil
      end
    end
    context 'Invalid record should raise error' do
      it 'when password has less than 6 char' do
        expect{
          User.create!(name: 'Reader Boy', email: 'test@email.com.br', password: '1234', password_confirmation: '1234')
        }.to raise_error ActiveRecord::RecordInvalid
      end
      it 'when email is missing' do
        expect{
          User.create!(name: 'Reader Boy', password: '123456', password_confirmation: '123456')
        }.to raise_error ActiveRecord::RecordInvalid
      end
      it 'when name is missing' do
        expect{
          User.create!(email: 'test@email.com.br', password: '123456', password_confirmation: '123456')
        }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
