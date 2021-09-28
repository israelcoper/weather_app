class ChangeLocationsToAddresses < ActiveRecord::Migration[5.1]
  def change
    rename_table :locations, :addresses
  end
end
