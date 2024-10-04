class Wallet < ApplicationRecord
	has_many :source_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
	has_many :target_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'
	belongs_to :entity, polymorphic: true

	validates :balance, numericality: { greater_than_or_equal_to: 0 }

	def deposit(amount)
  	ActiveRecord::Base.transaction do
  		CreditTransaction.create!(target_wallet: self, transaction_type: 'credit', amount: amount)
      update_balance
    end
	end

	def withdraw(amount)
		raise "Insufficient balance" if self.balance < amount

    ActiveRecord::Base.transaction do
      DebitTransaction.create!(source_wallet: self, transaction_type: 'debit', amount: amount)
      update_balance
    end
	end

	def transfer(target_wallet, amount)
    raise "Insufficient balance" if self.balance < amount

    ActiveRecord::Base.transaction do
      TransferTransaction.create!(source_wallet: self, target_wallet: target_wallet, transaction_type: 'transfer', amount: amount)
      update_balance
      target_wallet.update_balance
    end
  end

  def update_balance
    total_credit = target_transactions.sum(:amount)
    total_debit = source_transactions.sum(:amount)
    new_balance = total_credit - total_debit

    update!(balance: new_balance)
  end
end