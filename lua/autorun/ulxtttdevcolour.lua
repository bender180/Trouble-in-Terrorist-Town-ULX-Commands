--experiment to see what happens if i colour my name (will be removed if it causes issues)

if SERVER then
    AddCSLuaFile("ulxtttdevcolour.lua")
    else
    function ulxtttdevcolour(ply)
        if ply:SteamID() == "STEAM_0:1:31456488" then
            return Color(100, 240, 105, 255)
        end
      end
      hook.Add("TTTScoreboardColorForPlayer", "ulxtttdevcolour", ulxtttdevcolour)
end