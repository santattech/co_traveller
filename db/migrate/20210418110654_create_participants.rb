class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.integer :customer_id
      t.integer :planned_tour_id

      t.timestamps
    end

    add_index :participants, [:customer_id, :planned_tour_id], name: 'customer_planned_tour_idx', unique: true
  end
end
