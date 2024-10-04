class User < ApplicationRecord
  has_one :wallet, as: :entity
end