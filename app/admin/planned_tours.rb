ActiveAdmin.register PlannedTour do


  action_item :add_participant, only: :show do
    link_to "Add Particiapnts", add_participant_admin_planned_tour_path(planned_tour.id), method: :get
  end
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

  show do
    attributes_table do
      row :name
      row :start_date
      row :end_date

      row :description do |p|
        p.description.to_s.html_safe
      end

      row :updated_at
    end

    panel "Participants" do
      table_for planned_tour.participants do
        column :name do |participant|
          participant.customer.name
        end

        column :phone_number do |participant|
          participant.customer.phone_number
        end
      end
    end

  end

  member_action :add_participant, method: :get do
    @planned_tour = PlannedTour.find(params[:id])
  end

  member_action :submit_participant, method: :put do
    planned_tour = PlannedTour.find(params[:id])
    customer = Customer.find_by(id: params[:participant][:customer_id])

    if customer && planned_tour
      participant = planned_tour.participants.create!(customer_id: customer.id)
      redirect_to admin_planned_tour_path(planned_tour.id), notice: "Added successfully"
    else
      redirect_to admin_planned_tour_path(planned_tour.id), alert: "It is already added or any other errors"
    end
  rescue => e
    redirect_to admin_planned_tour_path(planned_tour.id), alert: e.message
  end

end
