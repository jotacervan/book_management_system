class Book < ApplicationRecord
  validates_presence_of :name
  has_many :transactions

  def image
    return '/book_placeholder.png' if self.image_url.blank?
    self.image_url
  end

  def is_available?
    self.transactions&.active.blank?
  end
end
