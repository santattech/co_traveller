class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone_number, null: false
      t.string :sex, default: 'male', null: false
      t.text :address

      t.timestamps
    end
  end
end
