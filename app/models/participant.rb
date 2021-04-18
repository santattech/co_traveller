class Participant < ApplicationRecord
  belongs_to :customer
  belongs_to :planned_tour

  validates_presence_of :customer_id, :planned_tour_id
  validates_uniqueness_of :customer_id, scope: :planned_tour_id
end
