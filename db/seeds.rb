# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
unless ParkingLot.find_by_name("LotA")
  ParkingLot.create!(name: "LotA", max_motorcycle_spots: 5, max_car_spots: 20, max_van_spots: 5)
end