class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.float :amount
      t.integer :trip_id
      t.string :currency
      t.string :category
      t.date :date
      t.string :desc

      t.timestamps
    end
  end
end
