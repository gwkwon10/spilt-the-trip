class Owe < ApplicationRecord
    belongs_to :userOwed, class_name: 'User'
    belongs_to :userOwing, class_name: 'User'
end
