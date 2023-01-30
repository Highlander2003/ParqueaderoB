class ParkingLot < ApplicationRecord
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :parking_spots

  def reserve_parking_spots(params)
    consecutive_spots = 1

    # Find next parking spot
    spot_type, spot_number = self.next_parking_spot(params[:vehicle_type])

    # If no spots available then bail
    if spot_number.nil?
      raise StandardError.new(message: "No more available spots left for #{params[:vehicle_type].pluralize}")
    end

    # If we are a car and the only next parking spot is a car, take up 3 spots
    reserve_parking_spots = []
    if spot_type == "car" && params[:vehicle_type] == "van"
      consecutive_spots = 3
    end

    # Record number of spots being taken to database
    ActiveRecord::Base.transaction do
      (0..consecutive_spots - 1).each do |free_spot|
        reserved_spot = ParkingSpot.new(
          parking_lot_id: self.id,
          spot_type: spot_type,
          vehicle_type: params[:vehicle_type],
          vehicle_plate: params[:vehicle_plate],
          spot_number: "#{spot_type}_#{spot_number + free_spot}"
        )
        unless reserved_spot.save!
          raise ActiveRecord::Rollback
        end
        reserve_parking_spots << reserved_spot
      end
    end

    # Return payload on spots taken
    reserve_parking_spots
  end

  def next_parking_spot(vehicle_type)
    next_parking_spot = nil

    # Per each type of vehicle, determine the next available parking spot
    if vehicle_type == "motorcycle"
      # Find a free motorcycle parking spot, if none exist, then try car and van parking spots
      next_parking_spot = find_free_parking_spot(max_motorcycle_spots, vehicle_type)
      next_parking_spot = find_free_parking_spot(max_car_spots, "car") unless next_parking_spot
      next_parking_spot = find_free_parking_spot(max_van_spots, "van") unless next_parking_spot
    elsif vehicle_type == "car"
      # Find a free car parking spot, if none exist, then try van parking spots
      next_parking_spot = find_free_parking_spot(max_car_spots, vehicle_type)
      next_parking_spot = find_free_parking_spot(max_van_spots, "van") unless next_parking_spot
    elsif vehicle_type == "van"
      # Find a free van parking spot, if none exist, then try 3 consecutive car parking spots
      next_parking_spot = find_free_parking_spot(max_van_spots, vehicle_type)
      next_parking_spot = find_free_parking_spot(max_car_spots, "car", 3) unless next_parking_spot
    end

    next_parking_spot
  end

  def find_free_parking_spot(max_spots, vehicle_type, consecutive_spots = 1)
    next_parking_spot = nil
    # Get number of spots left per base vehicle type
    spots = parking_spots.spot_type_spots(vehicle_type).order(:spot_number).pluck(:spot_number)

    # Per max number of spots per vehicle type, find a free parking spot
    (1..max_spots).each do |free_spot|
      unless spots.include?("#{vehicle_type}_#{free_spot}")
        # Add support for more than 1 consecutive spot. i.e. van parking in car spots
        if consecutive_spots > 1
          # If we are at the end of the row of spots, bail, we must not have enough consecutive spots
          return nil if free_spot + (consecutive_spots - 1) > max_spots

          free_consecutive_spots = true
          (1..(consecutive_spots - 1)).each do |consecutive_spot|
            free_consecutive_spots = false if spots.include?("#{vehicle_type}_#{free_spot + consecutive_spot}")
          end
          # If unable to find free consecutive spots, then try next set of free spots
          next unless free_consecutive_spots
        end
        next_parking_spot = free_spot
        break
      end
    end

    return nil if next_parking_spot.nil?

    [vehicle_type, next_parking_spot]
  end

  def spots_remaining
    # Find the number of remaining spots for each type,
    #   since vehicles can park in different spots take the max of 0 or number of spots
    @spots_remaining ||=
      {
        motorcycle_spots: [self.max_motorcycle_spots - parking_spots.vehicle_type_spots("motorcycle").count, 0].max,
        car_spots: [self.max_car_spots - parking_spots.vehicle_type_spots("car").count, 0].max,
        van_spots: [self.max_van_spots - parking_spots.vehicle_type_spots("van").count, 0].max,
      }
  end

  def spots_taken(vehicle_type)
    # Lets find out the type and number of spots each vehicle type os taking
    if vehicle_type == "motorcycle"
      {
        motorcycle_spots: parking_spots.vehicle_type_spots("motorcycle").where(spot_type: "motorcycle").count,
        car_spots: parking_spots.vehicle_type_spots("motorcycle").where(spot_type: "car").count,
        van_spots: parking_spots.vehicle_type_spots("motorcycle").where(spot_type: "van").count,
      }
    elsif vehicle_type == "car"
      {
        motorcycle_spots: 0,
        car_spots: parking_spots.vehicle_type_spots("car").where(spot_type: "car").count,
        van_spots: parking_spots.vehicle_type_spots("car").where(spot_type: "van").count,
      }
    elsif vehicle_type == "van"
      {
        motorcycle_spots: 0,
        car_spots: parking_spots.vehicle_type_spots("van").where(spot_type: "car").count,
        van_spots: parking_spots.vehicle_type_spots("van").where(spot_type: "van").count,
      }
    else
      {
        motorcycle_spots: parking_spots.vehicle_type_spots("motorcycle").count,
        car_spots: parking_spots.vehicle_type_spots("car").count,
        van_spots: parking_spots.vehicle_type_spots("van").count,
      }
    end
  end

  def parking_available?(vehicle_type)
    # Return true if there are any next parking spats per vehicle type
    next_parking_spot(vehicle_type).present?
  end

  def is_full?
    # If no remaining spots left then parking lot is full
    spots_remaining[:motorcycle_spots] == 0 && spots_remaining[:car_spots] == 0 && spots_remaining[:van_spots] == 0
  end

end
