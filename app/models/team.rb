class Team < ApplicationRecord
  has_one :wallet, as: :entity
end