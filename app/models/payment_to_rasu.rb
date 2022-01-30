class PaymentToRasu < ApplicationRecord
  validates_presence_of :description, :payment_date
end
