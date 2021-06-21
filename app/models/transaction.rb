class Transaction < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates_presence_of :start_date, :end_date
  validate :check_user_balance_and_book, :on => :create

  scope :active, -> { where(self.arel_table[:end_date].gteq(Date.current)) }

  def check_user_balance_and_book
    errors.add(:balance, "unavailable") if user && user.balance < 5
    errors.add(:book, "unavailable") unless book && book.is_available?
  end

  def as_json(options = {})
    unless options.blank?
      super(options)
    else
      { name: book.name, return_date: end_date }
    end
  end
end
