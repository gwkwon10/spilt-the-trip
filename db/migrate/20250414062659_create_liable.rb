class CreateLiable < ActiveRecord::Migration[8.0]
  def change
    create_table :liables do |t|
      t.integer :user_id
      t.float :amountLiable
      t.integer :expense_id

      t.timestamps
    end
  end
end
