if SERVER then
	print("#-----------------------------------------------#")
	print("|SimpleBP by redpr1sm is running on this server!|")
	print("#-----------------------------------------------#")
	util.AddNetworkString( "LocalHasGod" )
	util.AddNetworkString( "LocalPly" )

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
	
	net.Receive( "LocalPly", function( len, sender )
		local Pl = net.ReadEntity()
		if Pl:HasGodMode() then
			net.Start( "LocalHasGod" )
				net.WriteBool( Pl:HasGodMode() )
			net.Send( sender )
		end
	end)
end


if CLIENT then
	SX, SY = ScrW(), ScrH()
	ShieldTexture = {
		texture = surface.GetTextureID( "materials/shield/shield" ),
		color   = color_white,
		x       = SX/2+32,
		y       = 16,
		w       = 32,
		h       = 32
	}
	
	hook.Add("HUDPaint","",function()
		net.Start( "LocalPly" )
			net.WriteEntity( LocalPlayer() )
		net.SendToServer()
		net.Receive( "LocalHasGod", function()
			LocalHasGod=net.ReadBool()
		end)
		
		if LocalHasGod then
			draw.Text( {
				text   = "You have build protection.",
				font   = "HudHintTextLarge",
				pos    = {SX/2-80, 16},
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color  = color_white
			} )
			draw.TexturedQuad( ShieldTexture )
		end
	end)
end
