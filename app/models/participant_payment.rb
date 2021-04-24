class ParticipantPayment < ApplicationRecord
  belongs_to :participant
  belongs_to :planned_tour

  validates_presence_of :participant_id, :amount, :payment_type, :payment_date
  validates_numericality_of :amount

  TYPE = {
    advanced: 0,
    installment_1: 1,
    installment_2: 2,
    installment_3: 3,
    installment_4: 4,
    installment_5: 5
  }
end
