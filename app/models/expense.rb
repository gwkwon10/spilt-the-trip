class Expense < ApplicationRecord
    belongs_to :trip
    has_many :users, through: :liables
end
