class Expense < ApplicationRecord
    belongs_to :trip
    has_many :liables, dependent: :destroy
    has_many :users, through: :liables

    validate :date_within_trip

    private
    def date_within_trip
      if date < trip.startDate || date > trip.endDate
        errors.add(:date, "must be within the trip dates (#{trip.startDate} to #{trip.endDate})")
      end
    end

end
