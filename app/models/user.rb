class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :transactions
  
  validates_presence_of :name
  validates_uniqueness_of :account_number
  
  before_create :configure_balance_and_number

  def configure_balance_and_number
    self.balance = 50
    self.account_number = rand.to_s[2..10]
  end
end
