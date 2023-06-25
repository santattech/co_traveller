class FuelEntrySerializer < ResourceSerializer
  attributes :odometer, :quantity, :price

  attribute :entry_date do |object|
    object.entry_date.strftime('%Y-%m-%d')
  end

  attribute :total_price do |object|
    (object.quantity * object.price).round(2)
  end
end
