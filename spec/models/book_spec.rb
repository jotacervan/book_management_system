require 'rails_helper'

RSpec.describe Book, type: :model do
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
