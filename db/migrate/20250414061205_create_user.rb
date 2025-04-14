class CreateUser < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :displayName
      t.string :email
      t.string :password
      t.string :username

      t.timestamps
    end
  end
end
