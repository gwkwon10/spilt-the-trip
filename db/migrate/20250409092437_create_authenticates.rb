class CreateAuthenticates < ActiveRecord::Migration[8.0]
  def change
    create_table :authenticates do |t|
      t.integer :user_id
      t.string :password

      t.timestamps
    end
  end
end
