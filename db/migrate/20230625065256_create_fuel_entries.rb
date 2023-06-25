class CreateFuelEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :fuel_entries do |t|
      t.integer :odometer, default: 0, null: false
      t.datetime :entry_date, null: false
      t.decimal :quantity, default: 0, null: false
      t.decimal :price, default: 0, null: false

      t.timestamps
    end
  end
end
