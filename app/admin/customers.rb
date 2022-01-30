ActiveAdmin.register Customer do
  menu parent: "Users", label: "Customers", priority: 2
  config.batch_actions = false
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :phone_number, :sex, :address, :age, :adhar_no
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :phone_number, :sex, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    id_column
    column :name
    column :sex do |c|
      c.sex.capitalize
    end

    column :age do |c|
      pluralize(c.age.to_i, 'year')
    end

    column :adhar_no
    column :phone_number
    column :updated_at

    actions
  end


  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :phone_number
      f.input :sex, as: :select, collection: ["male", "female"]
      f.input :age
      f.input :adhar_no
      f.input :address
    end

    para "Press cancel to return to the list without saving."
    actions
  end
end
