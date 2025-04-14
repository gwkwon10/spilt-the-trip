class User < ApplicationRecord
    has_secure_password
    
    has_many :owned_trips, class_name: 'Trip', dependent: :destroy
    has_many :trips, through: :on_trips
    has_many :users, through: :owes
    has_many :owes_as_user_owed, class_name: 'Owe', foreign_key: 'userOwed_id'
    has_many :owes_as_user_owing, class_name: 'Owe', foreign_key: 'userOwing_id'
    has_many :userOwed, through: :owes_as_user_owed, source: :userOwing
    has_many :userOwing, through: :owes_as_user_owing, source: :userOwed

    #validates :username, presence:true, uniqueness:true, length:{minimum:6, maximum:20}
    #validates :password, presence:true, length:{minimum:8}

    #after_create :log_new_user

    #private
    #    def log_new_user
    #        puts "A new user was registered"
    #    end
end
