class AddBalanceToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :balance, :int
    add_column :users, :account_number, :int
  end
end
