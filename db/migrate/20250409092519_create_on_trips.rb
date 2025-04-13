class CreateOnTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :on_trips do |t|
      t.belongs_to :user
      t.belongs_to :trip

      t.timestamps
    end
  end
end
