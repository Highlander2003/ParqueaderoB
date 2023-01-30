class Api::V1::ParkingLotController < ApplicationController

  def spots_remaining
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])

    if parking_lot
      spots_remaining = parking_lot.spots_remaining
      render json: {status: "SUCCESS", message: "Fetched parking spots remaining successfully", data: spots_remaining}, status: :ok
    else
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found
    end
  end

  def spots_taken
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])

    if parking_lot
      spots_taken = parking_lot.spots_taken(params[:vehicle_type])
      render json: {status: "SUCCESS", message: "Fetched parking spots taken successfully", data: spots_taken}, status: :ok
    else
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found
    end
  end

  def parking_available
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])
    if params[:vehicle_type].nil? || !["car", "motorcycle", "van"].include?(params[:vehicle_type])
      render json: {status: "ERROR", message: "Missing query param vehicle_type"}, status: :bad_request and return
    end

    if parking_lot
      parking_available = parking_lot.parking_available?(params[:vehicle_type])
      render json: {status: "SUCCESS", message: "Fetched parking available successfully", data: parking_available}, status: :ok
    else
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found
    end
  end

  def is_full
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])

    if parking_lot
      render json: {status: "SUCCESS", message: "Determined parking log capacity successfully", data: parking_lot.is_full?}, status: :ok
    else
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found
    end
  end

  def park
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])
    unless parking_lot
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found and return
    end

    parking_spots = ParkingSpot.where(vehicle_plate: params[:vehicle_plate])
    if parking_spots.present?
      render json: {status: "ERROR", message: "Vehicle #{params[:vehicle_plate]} is already parked"}, status: :unprocessable_entity and return
    end

    reserve_parking_spots = parking_lot.reserve_parking_spots(params)

    render json: {status: "SUCCESS", message: "Vehicle was parked successfully", data: reserve_parking_spots}, status: :ok
  rescue StandardError => e
    render json: {status: "ERROR", message: e.message}, status: :unprocessable_entity
  end

  def remove
    parking_lot = ParkingLot.find_by_name(params[:parking_lot_name])

    if parking_lot
      parking_spots = ParkingSpot.where(vehicle_plate: params[:vehicle_plate])
      freed_spots = parking_spots.count
      parking_spots.each do|spot|
        spot.destroy
      end

      render json: {status: "SUCCESS", message: "Freed up #{freed_spots} parking spots", data: []}, status: :ok
    else
      render json: {status: "ERROR", message: "Parking lot does not exist"}, status: :not_found
    end
  end

end