class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.decimal :lat, null: false
      t.decimal :lng, null: false
      t.json :other_info

      t.timestamps
    end
  end
end
