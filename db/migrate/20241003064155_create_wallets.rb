class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.string :entity_type
      t.integer :entity_id
      t.decimal :balance, precision: 15, scale: 2, default: 0

      t.timestamps
    end
    
    add_index :wallets, [:entity_type, :entity_id]
  end
end
