class Stock < ApplicationRecord
  has_one :wallet, as: :entity
end