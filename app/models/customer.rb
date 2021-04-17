class Customer < ApplicationRecord
  validates_presence_of :name, :phone_number, :sex

end
