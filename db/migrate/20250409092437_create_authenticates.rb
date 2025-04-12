class CreateAuthenticates < ActiveRecord::Migration[8.0]
  def change
    create_table :authenticates do |t|
      t.string :password

      t.belongs_to :user

      t.timestamps
    end
  end
end
