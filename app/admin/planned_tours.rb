ActiveAdmin.register PlannedTour do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :start_date, :end_date, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :start_date, :end_date, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    id_column
    column :name
    column :start_date
    column :end_date
    column :description do |p|
      p.description.to_s.first(50) + "..."
    end

    column :updated_at

    actions
  end
end
