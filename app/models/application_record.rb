class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

# class Table < ApplicationRecord
#   attr_accessible :col, :col2, :col3
# end

# t = Table.[new/create] col: 'A', col2: 24
# new: t is a Table object
# create: t is Table obj, t added to db
# t.destroy

# t = Table.find 24   # by :id
# t = Table.findby col: 'A' # may be .find_by
# .where is .findby but returns multiple
# t = Table.all   # or .first .last

# t.col = 'B'
# t.save to save changes to :col


=begin
# Might need attr_accessible?

class User < ApplicationRecord
  attr_accessible :username, :dislayName
end

class Authenticate < ApplicationRecord
  attr_accessible :user_id, :password
end

class Owes < ApplicationRecord
  attr_accessible :uidOwes, :uidOwed, :amountOwed
end

class Trip < ApplicationRecord
  attr_accessible :startDate, :endDate, :name, :ownerid, :defaultCurrency
end

class OnTrip < ApplicationRecord
  attr_accessible :user_id, :trip_id, :balance
end

class Expense < ApplicationRecord
  attr_accessible :amount, :trip_id, :currency, :category, :date, :desc
end

class Liable < ApplicationRecord
  attr_accessible :user_id, :amountLiable, :expense_id
end

=end