class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.date :startDate
      t.date :endDate
      t.string :name
      t.string :defaultCurrency

      t.belongs_to :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
