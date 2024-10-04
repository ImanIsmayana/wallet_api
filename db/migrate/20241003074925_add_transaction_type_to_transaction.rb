class AddTransactionTypeToTransaction < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :transaction_type, :string
  end
end
