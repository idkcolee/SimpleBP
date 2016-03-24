print("#-----------------------------------------------#")
print("|SimpleBP by redpr1sm is running on this server!|")
print("#-----------------------------------------------#")

if SERVER then
	local function spawnProtect( ply )
		if IsValid( ply ) and not ply:HasGodMode() then
			ply:GodEnable()
			ply:ChatPrint("You now have build protection. (Spawned)")
		end
	end

	local Safe = { ["weapon_physgun"] = true, ["gmod_tool"] = true, ["gmod_camera"] = true }
	local function badWeapon( ply, old, new )
		if IsValid( ply ) and IsValid( new ) and not Safe[new:GetClass()] then
			ply:GodDisable()
			ply:ChatPrint("You've lost build protection! (Equipped weapon)")
		end
	end

	local function enterVehicle( ply, veh )
		if IsValid( ply ) and IsValid( veh ) then
			ply:GodDisable()
			ply:ChatPrint("You've lost build protection! (Entered vehicle)")
		end
	end
	
	hook.Add("PlayerSpawn","SimpleBP PlayerSpawn",spawnProtect)
	hook.Add("PlayerSwitchWeapon","SimpleBP PlayerSwitchWeapon",badWeapon)
	hook.Add( "PlayerEnteredVehicle", "SimpleBP PlayerEnteredVehicle", enterVehicle )
end
