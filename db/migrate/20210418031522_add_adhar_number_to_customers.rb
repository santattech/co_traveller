class AddAdharNumberToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :adhar_no, :string
    add_column :customers, :age, :integer
    remove_column :customers, :email
  end
end
