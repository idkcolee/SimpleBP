if SERVER then
	resource.AddFile( "shield.vmt" )
	print( "#-----------------------------------------------#" )
	print( "|SimpleBP by redpr1sm is running on this server!|" )
	print( "#-----------------------------------------------#" )

	local function spawnProtect( ply )
		if IsValid( ply ) and not ply:HasGodMode() then
			ply:GodEnable()
			ply:SetNWBool( "SimpleBP", true )
			ply:ChatPrint( "You now have build protection. (Spawned)" )
		end
	end

	local Safe = { ["weapon_physgun"] = true, ["gmod_tool"] = true, ["gmod_camera"] = true }
	local function badWeapon( ply, old, new )
		if IsValid( ply ) and IsValid( new ) and not Safe[ new:GetClass() ] and ply:HasGodMode() then
			ply:GodDisable()
			ply:SetNWBool( "SimpleBP", false )
			ply:ChatPrint( "You've lost build protection! (Equipped weapon)" )
		end
	end

	local function enterVehicle( ply, veh )
		if IsValid( ply ) and IsValid( veh ) and ply:HasGodMode() then
			ply:GodDisable()
			ply:SetNWBool( "SimpleBP", false )
			ply:ChatPrint( "You've lost build protection! (Entered vehicle)" )
		end
	end
	
	hook.Add( "PlayerSpawn", "SimpleBP", spawnProtect )
	hook.Add( "PlayerSwitchWeapon", "SimpleBP", badWeapon )
	hook.Add( "PlayerEnteredVehicle", "SimpleBP", enterVehicle )
end


if CLIENT then
	local ShieldTexture = {
		texture = surface.GetTextureID("shield"),
		color   = color_white,
		x       = 0,
		y       = 8,
		w       = 32,
		h       = 32
	}
	
	hook.Add("HUDPaint","",function()
		local SX, SY = ScrW(), ScrH()
		
		if LocalPlayer:GetNWBool("SimpleBP", false) then
			draw.Text( {
				text   = "You have build protection.",
				font   = "HudHintTextLarge",
				pos    = {SX/2-94.5, 16},
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color  = color_white
			} )
			
			ShieldTexture.x = SX/2
			draw.TexturedQuad( ShieldTexture )
		end
	end)
end
