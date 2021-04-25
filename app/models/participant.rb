class Participant < ApplicationRecord
  belongs_to :customer
  belongs_to :planned_tour

  has_many :participant_payments

  validates_presence_of :customer_id, :planned_tour_id
  validates_uniqueness_of :customer_id, scope: :planned_tour_id

  def total_amount_paid
    participant_payments.sum(&:amount)
  end
end
