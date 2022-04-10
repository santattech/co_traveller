class CreatePinCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :pin_codes do |t|
      t.string :pin_code
      t.string :place
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
