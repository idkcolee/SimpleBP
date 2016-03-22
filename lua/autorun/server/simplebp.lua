if not SERVER then return end
print("SimpleBP by redpr1sm is running on this server!")

function spawnProtect( ply )
    if IsValid( ply ) and not ply:HasGodMode() then
        ply:GodEnable()
        ply:ChatPrint("You now have build protection. (Spawned)")
    end
end
hook.Add("PlayerSpawn","",spawnProtect)

function tableContains( target, element )
    for K,V in pairs(target) do
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
        ply:ChatPrint("You've lost build protection! (Equipped weapon)")
    end
end
hook.add("PlayerSwitchWeapon","",badWeapon)

function enterVehicle( ply, veh )
    if IsValid( ply ) and IsValid( veh ) then
        ply:GodDisable()
        ply:ChatPrint("You've lost build protection! (Entered vehicle)")
    end
end
hook.Add("PlayerEnteredVehicle","",enterVehicle)

function findPlayers()
    T=nil
    T=ents.FindByClass( "player" )
end
hook.Add("PlayerConnect","",findPlayers)
hook.Add("PlayerDisconnected","",findPlayers)
