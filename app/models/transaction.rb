class Transaction < ApplicationRecord
	belongs_to :source_wallet, class_name: 'Wallet', optional: true
  	belongs_to :target_wallet, class_name: 'Wallet', optional: true

  	validates :amount, presence: true, numericality: { greater_than: 0 }

  	after_create :update_wallet_balances

  	private

  	def update_wallet_balances
	    if transaction_type == 'credit'
	      target_wallet.update!(balance: target_wallet.balance + amount)
	    elsif transaction_type == 'debit'
	      raise "Insufficient balance" if source_wallet.balance < amount
	      source_wallet.update!(balance: source_wallet.balance - amount)
	    end
  	end
end
