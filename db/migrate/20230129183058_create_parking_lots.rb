class CreateParkingLots < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_lots do |t|
      t.string :name
      t.integer :max_motorcycle_spots
      t.integer :max_car_spots
      t.integer :max_van_spots

      t.timestamps
    end
  end
end
