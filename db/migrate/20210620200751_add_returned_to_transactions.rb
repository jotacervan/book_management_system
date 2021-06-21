class AddReturnedToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :returned, :boolean, null: true
  end
end
