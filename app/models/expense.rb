class Expense < ApplicationRecord
    belongs_to :trip
    belongs_to :payer, class_name: "User", foreign_key: "traveler_id", optional: true
    has_many :liables, dependent: :destroy
    has_many :users, through: :liables
end
