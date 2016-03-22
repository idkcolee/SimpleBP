function spawnProtect( ply )
    if IsValid( ply ) and not ply:HasGodMode() then
        ply:GodEnable()
        ply:ChatPrint("You now have build protection.")
    end
end
hook.add("PlayerSpawn","",spawnProtect)

function tableContains( element )
    
end

Safe = { "weapon_physgun", "gmod_tool", "gmod_camera" }
function badWeapon( ply, old, new )
    if IsValid( ply ) and not Safe:tableContains( new:GetClass() ) then
        
    end
end
