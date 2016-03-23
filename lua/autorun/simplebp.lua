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
		if IsValid( ply ) and IsValid( new ) and not tableContains( Safe, new:GetClass() ) and ply:HasGodMode() then
			ply:GodDisable()
			ply:ChatPrint( "You've lost build protection! (Equipped weapon)" )
		end
	end
	hook.Add( "PlayerSwitchWeapon", "", badWeapon )

	function enterVehicle( ply, veh )
		if IsValid( ply ) and IsValid( veh ) and ply:HasGodMode() then
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
	
	local SX, SY = ScrW(), ScrH()
	local ShieldTexture = {
		texture = surface.GetTextureID( "materials/shield/shield" ),
		color   = Color( 255,255,255,255 ),
		x       = SX/2,
		y       = SY/2,
		w       = 64,
		h       = 64
	}
	
	hook.Add("HUDPaint","",function()
		if LocalPlayer():HasGodMode() then
			draw.SimpleText( "You have build protection.", "HudHintTextLarge", SX/2, SY/2, { 0,0,0,255 }, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.TexturedQuad( ShieldTexture )
		end
	end)
end
