if SERVER then
	print("#-----------------------------------------------#")
	print("|SimpleBP by redpr1sm is running on this server!|")
	print("#-----------------------------------------------#")
	util.AddNetworkString("PlyTable")

	function spawnProtect( ply )
		if IsValid( ply ) and not ply:HasGodMode() then
			ply:GodEnable()
			ply:ChatPrint( "You now have build protection. (Spawned)" )
		end
	end
	hook.Add( "PlayerSpawn", "", spawnProtect )

	function tableContains( target, element )
		for K,V in pairs( target ) do
			if V==element then
				return true
			end
		end
		return false
	end

	Safe = { "weapon_physgun", "gmod_tool", "gmod_camera" }
	function badWeapon( ply, old, new )
		if IsValid( ply ) and IsValid( new ) and not tableContains( Safe, new:GetClass() ) then
			ply:GodDisable()
			ply:ChatPrint( "You've lost build protection! (Equipped weapon)" )
		end
	end
	hook.Add( "PlayerSwitchWeapon", "", badWeapon )

	function enterVehicle( ply, veh )
		if IsValid( ply ) and IsValid( veh ) then
			ply:GodDisable()
			ply:ChatPrint( "You've lost build protection! (Entered vehicle)" )
		end
	end
	hook.Add( "PlayerEnteredVehicle", "", enterVehicle )

	function findPlayers()
		T=nil
		T=ents.FindByClass( "player" )

		net.Start( "PlyTable" )
			net.WriteTable( T )
		net.Broadcast()
	end
	hook.Add( "PlayerConnect", "", findPlayers )
	hook.Add( "PlayerDisconnected", "", findPlayers )
end


if CLIENT then
	net.Receive( "PlyTable", function()
		T=net.ReadTable()
	end)
	
	local X, Y = ScrW(), ScrH()
	surface.SetTextPos( X/2, Y/2 )
	surface.SetTextColor( 0,0,0,255 )
	surface.SetFont( "HudHintTextLarge" )
	sh=surface.GetTextureID( "materials/shield/shield" )
	surface.SetTexture( sh )
	
	hook.Add("HUDPaint","",function()
		if LocalPlayer():HasGodMode() then
			surface.DrawText( "You have build protection." )
			surface.DrawTexturedRectangle( X/2, Y/2, 64, 64 )
		end
	end)
end
