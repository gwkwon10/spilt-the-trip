class Trip < ApplicationRecord
    belongs_to :owner, class_name: 'User', foreign_key: "ownerid"
    has_many :on_trips, dependent: :destroy
    has_many :users, through: :on_trips
    has_many :expenses, dependent: :destroy
    # here we put methods
    #Pp0_)-
end
