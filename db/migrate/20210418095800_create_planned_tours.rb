class CreatePlannedTours < ActiveRecord::Migration[6.0]
  def change
    create_table :planned_tours do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :description

      t.timestamps
    end
  end
end
