ActiveAdmin.register Participant do
  menu parent: "Tours", label: "Participants", priority: 2
  menu false

  config.batch_actions = false

  controller do
    actions :all, except: [:destroy, :new, :create, :edit]
  end

  action_item :add_payment, only: :show do
    link_to "Add Payment", new_admin_participant_payment_path(participant_id: participant.id, planned_tour_id: participant.planned_tour_id), method: :get
  end

  show do
    attributes_table do
      row :customer do |p|
        p.customer
      end

      row :planned_tour do |p|
        p.planned_tour
      end

      row :amount do |p|
        p.participant_payments.sum(&:amount)
      end
    end

    panel "Payment details" do
      table_for participant.participant_payments do
        column :payment_id do |p|
           p.id
        end

        column :payment_date do |p|
           p.payment_date
        end

        column :payment_type do |p|
          ParticipantPayment::TYPE.key(p.payment_type)
        end

        column :amount do |p|
           p.amount
        end
      end
    end

  end
end
