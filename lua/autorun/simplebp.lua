if SERVER then
	-- INITIALIZE        ---------------------------------------------------------------------------------
	
	--- Only physgun, toolgun, and camera are safe by default.
	--- If you want to add other items, you should be able to figure out the format easily.
	--- If not then you shouldn't be running a server.
	local Safe = { ["weapon_physgun"] = true, ["gmod_tool"] = true, ["gmod_camera"] = true }
	local HookIdent = "SimpleBP"

	resource.AddFile( "shield/shield.png" )
	print( "#-------------------------------------------------#" )
	print( "| SimpleBP by redpr1sm is running on this server! |" )
	print( "|                                                 |" )
	print( "|        Use simplebp_unload to unload it.        |" )
	print( "#-------------------------------------------------#" )

	for i,ply in pairs( player.GetAll() ) do
		ply:SetNWBool( "SimpleBP_BP", ply:HasGodMode() )
	end

	-- FUNCTIONS         ---------------------------------------------------------------------------------

	local function hasBP( ply )
		return ply:GetNWBool( "SimpleBP_BP", false )
	end

	-- HOOK FUNCTIONS    ---------------------------------------------------------------------------------
	
	-- Gives BP upon spawning
	local function spawnProtect( ply )
		if IsValid( ply ) and not hasBP(ply) then
			ply:GodEnable()
			ply:SetNWBool( "SimpleBP_BP", true )
			ply:ChatPrint( "You now have build protection. (Spawned)" )
		end
	end

		
	-- Removes BP upon equipping a weapon
	local function badWeapon( ply, old, new )
		if IsValid( ply ) and IsValid( new ) and not Safe[ new:GetClass() ] and hasBP( ply ) then
			ply:GodDisable()
			ply:SetNWBool( "SimpleBP_BP", false )
			ply:ChatPrint( "You've lost build protection! (Equipped weapon)" )
		end
	end

	-- Removes BP upon entering a vehicle
	local function enterVehicle( ply, veh )
		if IsValid( ply ) and IsValid( veh ) and hasBP( ply ) then
			ply:GodDisable()
			ply:SetNWBool( "SimpleBP_BP", false )
			ply:ChatPrint( "You've lost build protection! (Entered vehicle)" )
		end
	end

	-- Ensures players attempting to enter noclip have BP
	local function shouldAllowNoclip( ply, desiredState )
		if ply:IsAdmin() or hasBP(ply) or desiredState == false then
			return true
		end
		return false
	end

	-- Removes non-BP players from noclip if they have it enabled
	local function checkPlys()
		local plys = player.GetAll()
		for i,ply in pairs(plys) do
			if not shouldAllowNoclip(ply) then
				if ply:GetMoveType() == MOVETYPE_NOCLIP then
					ply:SetMoveType( MOVETYPE_WALK )
				end
			end
		end
	end
	
	-- HOOK REGISTRATION -------------------------------------------------------------------------------

	hook.Add( "PlayerSpawn", HookIdent, spawnProtect )
	hook.Add( "PlayerSwitchWeapon", HookIdent, badWeapon )
	hook.Add( "PlayerEnteredVehicle", HookIdent, enterVehicle )
	hook.Add( "PlayerNoClip", HookIdent, shouldAllowNoclip )
	hook.Add( "Tick", HookIdent, checkPlys )

	-- CONSOLE COMMANDS  -------------------------------------------------------------------------------

	-- Enable UI at top of screen
	concommand.Add( "simplebp_enable_ui", function( ply )
		ply:SetNWBool( "SimpleBP_UI", true )
		ply:PrintMessage( HUD_PRINTCONSOLE, "UI enabled." )
	end )

	-- Enable UI at top of screen
	concommand.Add( "simplebp_disable_ui", function( ply )
		ply:SetNWBool( "SimpleBP_UI", false )
		ply:PrintMessage( HUD_PRINTCONSOLE, "UI disabled." )
	end )

	-- Allow unloading of script (hooks, specifically) from console. Mostly for debugging.
	concommand.Add( "simplebp_unload", function( ply )
		if not ply:IsAdmin() then
			ply:PrintMessage( HUD_PRINTCONSOLE, "You cannot run this command without admin priveleges." )
		end

		local hooks = { "PlayerSpawn", "PlayerSwitchWeapon", "PlayerEnteredVehicle", "PlayerNoClip" }
		for i,name in pairs( hooks ) do
			hook.Remove( name, HookIdent )
		end

		for i,ply in pairs(player.GetAll()) do
			ply:SendLua("hook.Remove( 'HUDPaint','SimpleBP' )")
			ply:GodDisable()
			ply:SetNWBool( "SimpleBP_BP", false )
		end

		print( "SimpleBP has been unloaded. This command will no longer be valid." )
		concommand.Remove( "simplebp_unload" )
		concommand.Remove( "simplebp_enable_ui" )
		concommand.Remove( "simplebp_disable_ui" )
	end )
end


if CLIENT then

	-- Texture for shield at the top of screen to indicate BP
	local ShieldTexture = {
		texture = surface.GetTextureID( "shield/shield" ),
		color   = color_white,
		x       = 0,
		y       = 8,
		w       = 32,
		h       = 32
	}
	
	-- Draw shield + text
	hook.Add("HUDPaint","SimpleBP",function()	
		if not LocalPlayer():GetNWBool( "SimpleBP_UI", true ) then return end	

		local SX, SY = ScrW(), ScrH()

		if LocalPlayer():GetNWBool( "SimpleBP_BP" ) then
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
		else
			draw.Text( {
				text   = "You do not have build protection.",
				font   = "HudHintTextLarge",
				pos    = {SX/2-94.5, 16},
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color  = color_white
			} )
		end
	end)
end