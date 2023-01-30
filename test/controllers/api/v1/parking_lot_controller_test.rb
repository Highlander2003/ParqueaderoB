require "test_helper"

class ParkingLotControllerTest < ActionDispatch::IntegrationTest
  setup do
  end

  test "should get spots_remaining" do
    get api_v1_spots_remaining_path(parking_lot_name: "LotA")
    assert_response :success
  end

  test "should not get spots_remaining" do
    get api_v1_spots_remaining_path(parking_lot_name: "Bad Lot")
    assert_response :not_found
  end

  test "should get spots taken" do
    get api_v1_spots_taken_path(parking_lot_name: "LotA", vehicle_type: "car")
    assert_response :success
  end

  test "should not get spots taken" do
    get api_v1_spots_taken_path(parking_lot_name: "Bad Lot", vehicle_type: "car")
    assert_response :not_found
  end

  test "should get parking available" do
    get api_v1_parking_available_path(parking_lot_name: "LotA", vehicle_type: "car")
    assert_response :success
  end

  test "should not get parking available without vehicle type" do
    get api_v1_parking_available_path(parking_lot_name: "LotA", vehicle_type: "can")
    assert_response :bad_request
  end

  test "should not get parking available" do
    get api_v1_parking_available_path(parking_lot_name: "Bad Lot", vehicle_type: "car")
    assert_response :not_found
  end

  test "should get is full" do
    get api_v1_is_full_path(parking_lot_name: "LotA")
    assert_response :success
  end

  test "should not get is full" do
    get api_v1_is_full_path(parking_lot_name: "Bad Lot")
    assert_response :not_found
  end

  test "should park a vehicle" do
    post api_v1_park_path(parking_lot_name: "LotA"), params: {vehicle_plate: "MA_2", vehicle_type: "car"}
    assert_response :success
  end

  test "should not park same vehicle" do
    post api_v1_park_path(parking_lot_name: "LotA"), params: {vehicle_plate: "MA_1", vehicle_type: "car"}
    assert_response :unprocessable_entity
  end

  test "should not park a vehicle" do
    post api_v1_park_path(parking_lot_name: "Bad Lot"), params: {vehicle_plate: "MA_2", vehicle_type: "car"}
    assert_response :not_found
  end

  test "should remove parked vehicle" do
    delete api_v1_remove_path(parking_lot_name: "LotA", vehicle_plate: "MA_1")
    assert_response :success
  end

  test "should not remove parked vehicle" do
    delete api_v1_remove_path(parking_lot_name: "Bad Lot", vehicle_plate: "MA_1")
    assert_response :not_found
  end

end
