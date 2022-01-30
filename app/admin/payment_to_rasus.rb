ActiveAdmin.register PaymentToRasu do
  menu parent: "Personal", label: "Payment to Rasu", priority: 2
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :amount, :description, :payment_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:amount, :description, :payment_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
