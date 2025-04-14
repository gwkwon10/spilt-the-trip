class Owe < ApplicationRecord
    belongs_to :userOwed, class_name: 'User', foreign_key: "userOwed"
    belongs_to :userOwing, class_name: 'User', foreign_key: "userOwing"
end
