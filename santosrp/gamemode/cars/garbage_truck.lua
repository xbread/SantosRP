local Car = {}

Car.Make = "Truck"
Car.Name = "Garbage Truck"
Car.UID = "garbage_truck"
Car.Job = "JOB_SANITATION"
Car.Desc = ""
Car.Model = "models/sligwolf/garbagetruck/sw_truck.mdl"
Car.Script = "scripts/vehicles/sligwolf/sw_truck.txt"
Car.FuellTank = 120
Car.FuelConsumption = 20
Car.VehicleTable = "sw_garbagetruck"

GM.Cars:RegisterJobCar( Car )