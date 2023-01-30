# README

This README document steps to get the application up and running and tested.

## Local Development Setup

* Prerequisites:
    * Ruby 3.1.2
    * PostgreSQL 14.x
* Checkout repo
* Install gem dependencies: `bundle install`
* Setup database: `rake db:create db:migrate db:seed`

Note: The database gets setup with 1 parking lot named "LotA" with specific spots for 5 vans, 5 motorcycles, and 20 cars.

## How to run app

* Start server: `rails s`

## How to run unit tests

* Run `rake -t`

# API Routes

## GET parking_lot/:parking_lot_name/spots_remaining

API for getting spots remaining for every vehicle type.

### Route params

- parking_lot_name : string[] - name of parking lot

### Example request

`
curl -v -X GET "http://127.0.0.1:3000/api/v1/parking_lot/LotA/spots_remaining"
`

### Example response

```json
{
  "status": "SUCCESS",
  "message": "Fetched parking spots remaining successfully",
  "data": {
    "motorcycle_spots": 0,
    "car_spots": 19,
    "van_spots": 0
  }
}
```

## GET parking_lot/:parking_lot_name/spots_taken/(:vehicle_type)

API for getting spots taken, optionally by vehicle type

### Route params

- parking_lot_name : string[] - name of parking lot
- vehicle_type: string[] - optional type of vehicle (motorcycle, car, van)

### Example request

`
curl -v -X GET "http://127.0.0.1:3000/api/v1/parking_lot/LotA/spots_taken/car"
`

### Example response

```json
{
  "status": "SUCCESS",
  "message": "Fetched parking spots taken successfully",
  "data": {
    "motorcycle_spots": 0,
    "car_spots": 19,
    "van_spots": 0
  }
}
```

## GET parking_lot/:parking_lot_name/parking_available/:vehicle_type

API for getting available parking by vehicle type

### Route params

- parking_lot_name : string[] - name of parking lot
- vehicle_type: string[] - type of vehicle (motorcycle, car, van)

### Example request

`
curl -v -X GET "http://127.0.0.1:3000/api/v1/parking_lot/LotA/parking_available/van"
`

### Example response

```json
{
  "status": "SUCCESS",
  "message": "Fetched parking available successfully",
  "data": true
}
```

## GET parking_lot/:parking_lot_name/is_full

API to determine if parking lot is at capacity or not

### Route params

- parking_lot_name : string[] - name of parking lot

### Example request

`
curl -v -X GET "http://127.0.0.1:3000/api/v1/parking_lot/LotA/is_full"
`

### Example response

```json
{
  "status": "SUCCESS",
  "message": "Determined parking log capacity successfully",
  "data": false
}
```

## POST parking_lot/:parking_lot_name/park

API to park a vehicle

### Route params

- parking_lot_name : string[] - name of parking lot

### Body params

- vehicle_type : string[] - type of vehicle (motorcycle, car, van)
- vehicle_plate : string[] - vehicle plate number (unique per vehicle)

### Example Request

`
curl -v -X POST -H "Content-Type: multipart/form-data;" -d "vehicle_type=car&vehicle_plate=MA_12345" "http://127.0.0.1:3000/api/v1/parking_lot/LotA/park"
`

### Example Response

```json
{
  "status": "SUCCESS",
  "message": "Vehicle was parked successfully",
  "data": [
    {
      "id": 42,
      "parking_lot_id": 1,
      "spot_number": "car_14",
      "spot_type": "car",
      "vehicle_type": "car",
      "vehicle_plate": "MA_1234",
      "created_at": "2023-01-30T00:41:16.788Z",
      "updated_at": "2023-01-30T00:41:16.788Z"
    }
  ]
}

```

## DELETE parking_lot/:parking_lot_name/remove/:vehicle_plate

API to un-park a vehicle by vehicle plate number

### Route params

- parking_lot_name : string[] - name of parking lot
- vehicle_plate: string[] - vehicle plate number

### Example request

`
curl -v -X DELETE "http://127.0.0.1:3000/api/v1/parking_lot/LotA/remove/MA_3"
`

### Example response

```json
{
  "status": "SUCCESS",
  "message": "Freed up 1 parking spots",
  "data": []
}
```
