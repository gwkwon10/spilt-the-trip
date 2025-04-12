class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

# class Table < ApplicationRecord
#   attr_accessible :col, :col2, :col3
# end

# t = Table.[new/create] col: 'A', col2: 24
# new: t is a Table object
# create: t is Table obj, t added to db
# t.errors.full_messages # get format errors in creation
# t.destroy

# association: myTrip.user = myUser
# myUser.create_authenticate(password: "wombat12")
# myUsers = trip.users   # myUsers is an array of users in trip

# rails edgeguide:
# book = Book.new do |b|
#   b.title = "Metaprogramming Ruby 2"
#   b.author = "Paolo Perrotta"
# end
# book.save


# t = Table.find 24   # by :id
# t = Table.[findby/where] col: 'A'
# .where is .findby but returns multiple
# t = Table.all   # multiple. Or, .first .last .take gets 1

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