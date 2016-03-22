function spawnProtect( ply )
    if IsValid( ply ) and not ply:HasGodMode() then
        ply:GodEnable()
        ply:ChatPrint("You now have build protection.")
    end
end
hook.add("PlayerSpawn","",spawnProtect)
