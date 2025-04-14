class CreateOnTrip < ActiveRecord::Migration[8.0]
  def change
    create_table :on_trips do |t|
      t.integer :user_id
      t.integer :trip_id
      t.float :balance

      t.timestamps
    end
  end
end
