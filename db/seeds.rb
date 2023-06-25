# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if AdminUser.find_by(email: 'santattech@gmail.com').blank?
  AdminUser.create!(email: 'santattech@gmail.com', password: 'santattech', password_confirmation: 'santattech')
end

if FuelEntry.all.blank?
  FuelEntry.create(odometer: 32, price: 85, quantity: 12, entry_date: DateTime.parse('2021-02-20'))
  FuelEntry.create(odometer: 178, price: 87, quantity: 27, entry_date: DateTime.parse('2021-03-11'))
  FuelEntry.create(odometer: 677, price: 90, quantity: 12, entry_date: DateTime.parse('2021-04-30'))
  FuelEntry.create(odometer: 860, price: 95, quantity: 11, entry_date: DateTime.parse('2021-06-05'))
  FuelEntry.create(odometer: 990, price: 96, quantity: 8, entry_date: DateTime.parse('2021-07-24'))
end