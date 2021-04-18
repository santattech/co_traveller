class PlannedTour < ApplicationRecord
  validates_presence_of :name, :start_date, :end_date

  has_many :participants
end
