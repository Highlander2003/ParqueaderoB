class CreateParkingSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_spots do |t|
      t.integer :parking_lot_id
      t.string :spot_number
      t.string :spot_type
      t.string :vehicle_type
      t.string :vehicle_plate

      t.timestamps
    end
  end
end
