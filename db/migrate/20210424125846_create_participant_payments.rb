class CreateParticipantPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :participant_payments do |t|
      t.integer :payment_type, null: false
      t.integer :planned_tour_id, null: false
      t.decimal :amount, default: 0.0, null: false
      t.integer :participant_id, null: false
      t.date    :payment_date, null: false

      t.timestamps
    end

    add_foreign_key :participant_payments, :participants
    add_foreign_key :participant_payments, :planned_tours
  end
end
