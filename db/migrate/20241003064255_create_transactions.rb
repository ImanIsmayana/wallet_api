class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.bigint :source_wallet_id, null: true # credit
      t.bigint :target_wallet_id, null: true # debit
      t.decimal :amount, precision: 15, scale: 2

      t.timestamps
    end
    add_foreign_key :transactions, :wallets, column: :source_wallet_id
    add_foreign_key :transactions, :wallets, column: :target_wallet_id
  end
end
