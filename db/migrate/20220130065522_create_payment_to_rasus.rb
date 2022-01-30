class CreatePaymentToRasus < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_to_rasus do |t|
      t.integer :amount, default: 0
      t.text :description
      t.date :payment_date

      t.timestamps
    end
  end
end
