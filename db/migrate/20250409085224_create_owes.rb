class CreateOwes < ActiveRecord::Migration[8.0]
  def change
    create_table :owes do |t|
      t.integer :uidOwes
      t.integer :uidOwed
      t.float :amountOwed

      t.timestamps
    end
  end
end
