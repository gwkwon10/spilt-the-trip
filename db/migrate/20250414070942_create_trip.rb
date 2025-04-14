class CreateTrip < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.date :startDate
      t.date :endDate
      t.string :name
      t.integer :ownerid
      t.string :defaultCurrency

      t.timestamps
    end
  end
end
