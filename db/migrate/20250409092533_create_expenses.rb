class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.float :amount
      t.string :currency
      t.string :category
      t.date :date
      t.string :desc

      t.belongs_to :trip, foreign_key: true

      t.timestamps
    end
  end
end
