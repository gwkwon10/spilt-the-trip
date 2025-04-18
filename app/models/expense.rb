class Expense < ApplicationRecord
    belongs_to :trip
    belongs_to :payer, class_name: "User", foreign_key: "traveler_id", optional: true
    has_many :liables, dependent: :destroy
    has_many :users, through: :liables

    attr_accessor :traveler_id

    validate :date_within_trip
    validate :greater_than_zero

    private
    def date_within_trip
      if date < trip.startDate || date > trip.endDate
        errors.add(:date, "must be within the trip dates (#{trip.startDate} to #{trip.endDate})")
      end
    end

    def greater_than_zero
      if amount <= 0
        errors.add(:amount, "Amount must be greater than 0")
      end
    end

end
