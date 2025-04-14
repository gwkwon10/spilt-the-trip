class Trip < ApplicationRecord
    belongs_to :owner, class_name: 'User'
    has_many :users, through: :on_trips
    has_many :expenses
    # here we put methods
    #Pp0_)-
end
