class Book < ApplicationRecord
  validates_presence_of :name

  def image
    return '/book_placeholder.png' if self.image_url.blank?
    self.image_url
  end
end
