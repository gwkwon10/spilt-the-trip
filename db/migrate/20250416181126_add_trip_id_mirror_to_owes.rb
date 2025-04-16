class AddTripIdMirrorToOwes < ActiveRecord::Migration[6.1]
  def change
    add_column :owes, :trip_id_mirror, :integer
  end
end