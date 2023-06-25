class FuelEntry < ApplicationRecord
  validates_presence_of :entry_date, :price, :quantity
end
