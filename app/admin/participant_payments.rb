ActiveAdmin.register ParticipantPayment do
  menu parent: "Tours", label: "Payments", priority: 3

  config.batch_actions = false
  permit_params :payment_type, :participant_id, :amount, :payment_date, :planned_tour_id

  controller do
    def create
      @participant_payment = ParticipantPayment.create(participant_payment_params)

      redirect_to admin_planned_tour_path(@participant_payment.planned_tour_id), notice: "Created successfully"
    end

    def participant_payment_params
      params.require(:participant_payment).permit(:payment_type, :participant_id, :amount, :payment_date, :planned_tour_id)
    end
  end

  index download_links: false do
    column 'ID', sortable: 'id' do |p|
      p.id
    end

    column :payment_type do |p|
      ParticipantPayment::TYPE.key(p.payment_type)
    end

    column :planned_tour
    column :amount
    column :payment_date

    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :planned_tour_id, as: :select, collection: PlannedTour.where(id: params[:planned_tour_id]).map{|p| [p.name, p.id]}
      f.input :participant_id, as: :select, collection: Participant.where(id: params[:participant_id], planned_tour_id: params[:planned_tour_id]).map{|p| [p.customer.name, p.id]}
      f.input :payment_type, as: :select, collection: ParticipantPayment::TYPE.to_a
      f.input :amount
      f.input :payment_date

    end

    para "Press cancel to return to the list without saving."
    actions
  end
end
