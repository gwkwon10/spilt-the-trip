class CreateOwes < ActiveRecord::Migration[8.0]
  def change
    create_table :owes do |t|
      t.float :amountOwed

      t.belongs_to :userOwed, foreign_key: { to_table: :users }
      t.belongs_to :userOwing, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
