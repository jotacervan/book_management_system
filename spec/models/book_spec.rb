require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validate' do
    specify{ expect(Book.new()).to_not be_valid }
    specify{ expect(Book.new(name: 'New Book')).to be_valid }
    specify{ expect(Book.new(name: 'New Book', description: 'Some description', image_url: 'image_url')).to be_valid }
  end
  describe 'methods' do
    let!(:transaction){ create(:transaction, start_date: 2.days.ago, end_date: 2.days.from_now) } 
    it 'is_available?' do
      book = transaction.book 
      expect(book.is_available?).to be_falsy
    end
  end
  describe 'Create book' do
    it 'should create the book successfully' do
      Book.create(name: 'Test Book', description: 'Some description about the book', image_url: 'https://image_url')
      expect(Book.count).to be 1
    end
  end
  describe 'Update Book' do
    let!(:book){ create(:book) }
    it 'should update the books name' do
      book.update(name: 'New name')      
      book.reload
      expect(book.name).to eq 'New name'
    end
    it 'should not update name to nil' do
      book.update(name: nil)
      book.reload
      expect(book.name).to eq 'My Book'
    end
  end
  describe 'Destroy book' do
    let!(:book){ create(:book) }
    before { expect(Book.count).to eq 1 }
    it 'should delete the book' do
      book.destroy
      expect(Book.count).to eq 0
    end
  end
  describe 'image url' do
    let!(:book){ create(:book) }
    context 'without image_url' do
      before{ book.update(image_url: nil) }
      it 'should return the image placeholder' do
        expect(book.image).to eq '/book_placeholder.png' 
      end
    end
    context 'with image_url' do
      it 'should return the registered image' do
        expect(book.image).to eq 'http://image_url'
      end
    end
  end
end
