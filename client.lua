local QBCore = exports["qb-core"]:GetCoreObject()

local pilot = false

RegisterCommand("+oto", function(source, args)
	if(IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
		if(args[1] == "pilot") then
			waypoint = Citizen.InvokeNative(0xFA7C7F0AADF25D09, GetFirstBlipInfoId(8), Citizen.ResultAsVector())
			print(waypoint)
			if(IsWaypointActive()) then
				if(pilot) then
					pilot = false
					QBCore.Functions.Notify("Oto pilot iptal edildi.")
					ClearPedTasks(GetPlayerPed(-1))
				else
					pilot = true
					QBCore.Functions.Notify("Oto pilot aktif edildi.")
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)

					local maxSpeed = 50.0 

					TaskVehicleDriveToCoord(
						GetPlayerPed(-1), 
						vehicle, 
						waypoint["x"], 
						waypoint["y"], 
						waypoint["z"], 
						maxSpeed, 
						1.0, 
						GetHashKey(vehicle), 
						786468,
						1.0, 
						1
					)

					Citizen.CreateThread(function()
						while pilot do
							Wait(100)
							if GetEntitySpeed(vehicle) > maxSpeed then
								SetVehicleForwardSpeed(vehicle, maxSpeed)
							end
							
							if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), waypoint["x"], waypoint["y"], waypoint["z"], true) < 10.0 then
								pilot = false
								TaskVehiclePark(
									GetPlayerPed(-1), 
									vehicle, 
									waypoint["x"], 
									waypoint["y"], 
									waypoint["z"], 
									GetEntityHeading(vehicle),
									1, 
									20.0,
									true
								)
								
								Citizen.Wait(5000)
								QBCore.Functions.Notify("Araç başarıyla park edildi.", "success")
								ClearPedTasks(GetPlayerPed(-1))
							end
						end
					end)
				end
			else
				QBCore.Functions.Notify("Bir rota belirlemediniz.")
			end
		end
	end
end, false)