class CreateWeatherConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :weather_conditions do |t|
      t.integer :address_id
      t.string :city
      t.string :region
      t.string :country
      t.string :condition
      t.decimal :temperature_in_celcius
      t.datetime :date_time

      t.timestamps
    end
  end
end
