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