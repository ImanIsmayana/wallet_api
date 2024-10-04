class TransactionService
  def self.transfer(source_wallet, target_wallet, amount)
    ActiveRecord::Base.transaction do
      source_wallet.update!(balance: source_wallet.balance - amount)
      target_wallet.update!(balance: target_wallet.balance + amount)

      Transaction.create!(
        source_wallet: source_wallet,
        target_wallet: target_wallet,
        amount: amount,
        transaction_type: 'transfer'
      )
    end
  end
end
