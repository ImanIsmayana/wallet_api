class WalletsController < ApplicationController
	before_action :require_login
  before_action :check_required_create_wallets, only: [:create]

  def show
    wallet = Wallet.find(params[:id])
    render json: { wallet: wallet }
  end

  def create
    entity = find_entity
    wallet = entity.create_wallet(wallet_params)
    render json: wallet, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def wallet_params
    params.require(:wallet).permit(:entity_type, :entity_id, :balance)
  end

  def find_entity
    params[:entity_type].capitalize.constantize.find(params[:entity_id])
  end

  def check_required_create_wallets
    missing_params = []
    missing_params << 'entity_id' unless params[:entity_id].present?
    missing_params << 'entity_type' unless params[:entity_type].present?
    missing_params << 'balance' unless params[:balance].present?

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
    	return
    end

    if params[:entity_type].downcase != 'user' || params[:entity_type].downcase != 'team' || params[:entity_type].downcase != 'stock'
    	render json: { error: "entity_type value must be : user / team / stock" }, status: :unprocessable_entity
    	return
    end
  end
end
