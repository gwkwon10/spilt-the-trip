class Trip < ApplicationRecord
    belongs_to :owner, class_name: 'User'
    has_many :users
    has_many :expenses
    # here we put methods
    #Pp0_)-
end
