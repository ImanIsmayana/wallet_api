class TransactionsController < ApplicationController
	before_action :require_login
	before_action :check_validation_create_transaction, only: [:create]
	before_action :check_validation_tranfer, only: [:transfer]

  def create
    wallet = Wallet.find(params[:wallet_id])
    amount = params[:amount].to_d

    if params[:transaction_type] == 'credit'
      wallet.deposit(amount)
    elsif params[:transaction_type] == 'debit'
      wallet.withdraw(amount)
    else
      render json: { error: "Invalid transaction type, fill with credit or debit" }, status: :unprocessable_entity
    	return
    end

    render json: { message: "Transaction #{params[:transaction_type].capitalize} #{wallet.entity.name.capitalize} has been successful" }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def transfer
    source_wallet = Wallet.find(params[:source_wallet_id])
    target_wallet = Wallet.find(params[:target_wallet_id])
    amount = params[:amount].to_d

		source_wallet.transfer(target_wallet, amount)
    render json: { message: "Transfer from #{source_wallet.entity.name.capitalize} to #{target_wallet.entity.name.capitalize} has been successful" }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def check_validation_create_transaction
    missing_params = []
    missing_params << 'wallet_id' unless params[:wallet_id].present?
    missing_params << 'transaction_type (debit / credit)' unless params[:transaction_type].present?
    missing_params << 'amount' unless params[:amount].present?

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
    	return
    end

    if params[:amount] <= 0
    	render json: { error: "amount must be greater than 0" }, status: :unprocessable_entity
    	return
    end
  end

  def check_validation_tranfer
    missing_params = []
    missing_params << 'source_wallet_id' unless params[:source_wallet_id].present?
    missing_params << 'target_wallet_id' unless params[:target_wallet_id].present?
    missing_params << 'amount' unless params[:amount].present?

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
      return
    end

    if params[:amount] <= 0
    	render json: { error: "amount must be greater than 0" }, status: :unprocessable_entity
    	return
    end
  end
end