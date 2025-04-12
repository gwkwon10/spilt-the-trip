class CreateLiables < ActiveRecord::Migration[8.0]
  def change
    create_table :liables do |t|
      t.float :amountLiable
      t.float :paid

      t.belongs_to :user
      t.belongs_to :expense

      t.timestamps
    end
  end
end
