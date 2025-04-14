class CreateOwe < ActiveRecord::Migration[8.0]
  def change
    create_table :owes do |t|
      t.integer :userOwing
      t.integer :userOwed
      t.float :amountOwed

      t.timestamps
    end
  end
end
