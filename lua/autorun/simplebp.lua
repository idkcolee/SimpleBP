if not SERVER then return end
function spawnProtect( ply )
    if IsValid( ply ) and not ply:HasGodMode() then
        ply:GodEnable()
        ply:ChatPrint("You now have build protection.")
    end
end
hook.add("PlayerSpawn","",spawnProtect)

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
    if IsValid( ply ) and not tableContains( Safe, new:GetClass() ) then
        ply:GodDisable()
        ply:ChatPrint("You've lost build protection!")
    end
end

function inVehicle( ply, veh )
    if IsValid( ply ) and IsValid( veh ) then
        ply:GodDisable()
        ply:ChatPrint("You've lost build protection!")
    end
end
