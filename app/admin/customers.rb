ActiveAdmin.register Customer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :email, :phone_number, :sex, :address
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :phone_number, :sex, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone_number
      f.input :sex, as: :select, collection: ["male", "female"]
    end

    para "Press cancel to return to the list without saving."
    actions
  end
end
