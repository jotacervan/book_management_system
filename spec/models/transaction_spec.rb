require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:book){ create(:book) }
  let!(:user){ create(:user) }

  describe 'validations' do
    specify{ expect(Transaction.new(book: book, user: user)).to_not be_valid }
    specify{ expect(Transaction.new()).to_not be_valid }
    specify{ expect(Transaction.new(book: book, user: user, start_date: Date.current(), end_date: 5.days.from_now)).to be_valid } 
    specify{ expect(Transaction.new(book: book, start_date: Date.current(), end_date: 5.days.from_now)).to_not be_valid }
    specify{ expect(Transaction.new(user: user, start_date: Date.current(), end_date: 5.days.from_now)).to_not be_valid }
  end

  describe 'scopes' do
    let!(:tr1){ create(:transaction, user: user, start_date: 2.days.ago, end_date: 2.days.from_now) }
    let!(:tr2){ create(:transaction, user: user, start_date: 5.days.ago, end_date: Date.current) }
    let!(:tr3){ create(:transaction, user: user, start_date: 10.days.ago, end_date: 2.days.ago) }
    it 'should return only active transactions' do
      expect(Transaction.active).to eq([tr1, tr2])
    end
  end

  describe 'create transaction' do
    it "shoudn't create a transaction without start and end date" do
      transaction = Transaction.create(book: book, user: user)
      expect(Transaction.count).to eq 0
    end 
  end
  describe 'update transaction' do
    it "successfully" do
      transaction = create(:transaction, user: user)
      transaction.update(returned: true)
      expect(transaction.returned).to be true
    end
  end
end

