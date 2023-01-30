class ParkingSpot < ApplicationRecord
  enum vehicle_type: {motorcycle: "motorcycle", car: "car", van: "van"}

  validates_presence_of :spot_number
  validates_presence_of :vehicle_type
  validates_presence_of :vehicle_plate

  validates :vehicle_type, presence: true, inclusion: {in: vehicle_types.keys, message: "%{value} is an invalid vehicle type"}

  scope :vehicle_type_spots, ->(vehicle_type) { where("vehicle_type = ?", vehicle_type) }
  scope :spot_type_spots, ->(vehicle_type) { where("spot_type = ?", vehicle_type) }
end
