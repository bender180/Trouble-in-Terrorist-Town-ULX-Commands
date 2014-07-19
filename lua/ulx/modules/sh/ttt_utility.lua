--[=[-------------------------------------------------------------------------------------------
║                              Trouble in Terrorist Town Commands                              ║
║                                   By: Skillz and Bender180                                   ║
║                              ╔═════════╗╔═════════╗╔═════════╗                               ║
║                              ║ ╔═╗ ╔═╗ ║║ ╔═╗ ╔═╗ ║║ ╔═╗ ╔═╗ ║                               ║
║                              ╚═╝ ║ ║ ╚═╝╚═╝ ║ ║ ╚═╝╚═╝ ║ ║ ╚═╝                               ║
║──────────────────────────────────║ ║────────║ ║────────║ ║───────────────────────────────────║
║──────────────────────────────────║ ║────────║ ║────────║ ║───────────────────────────────────║
║──────────────────────────────────╚═╝────────╚═╝────────╚═╝───────────────────────────────────║
║                  All code included is completely original or extracted                       ║
║            from the base ttt files that are provided with the ttt gamemode.                  ║
║                                                                                              ║
---------------------------------------------------------------------------------------------]=]
local CATEGORY_NAME  = "TTT Utility"
local gamemode_error = "The current gamemode is not trouble in terrorest town"


---[Minimum players]----------------------------------------------------------------------------
function ulx.minply( calling_ply, players )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, gamemode_error, true ) else
		if players%2 ~= 0.5 then
			players = math.floor(players+0.5)
		else
			players = players - 0.5
		end
		ULib.consoleCommand( "ttt_minimum_players " .. players .. "\n" )
		ulx.fancyLogAdmin( calling_ply, "#A set the minimum number of players to ".. players .."." )
	end
end
local minply = ulx.command( CATEGORY_NAME, "ulx minply", ulx.minply )
minply:addParam{ type=ULib.cmds.NumArg, default=2, hint="minply", ULib.cmds.optional}
minply:defaultAccess( ULib.ACCESS_SUPERADMIN )
minply:help( "Sets the minimum number of players." )
---[End]----------------------------------------------------------------------------------------


---[Prevent win]-------------------------------------------------------------------------
function ulx.preventwin( calling_ply, should_prevwin )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, gamemode_error, true ) else
		if should_prevwin then
			ULib.consoleCommand( "ttt_debug_preventwin 0" .. "\n" )
			ulx.fancyLogAdmin( calling_ply, "#A allowed the round to end as normal." )
		else
			ULib.consoleCommand( "ttt_debug_preventwin 1" .. "\n" )
			ulx.fancyLogAdmin( calling_ply, "#A prevented the round from ending untill timeout." )
		end
	end
end
local preventwin = ulx.command( CATEGORY_NAME, "ulx prevwin", ulx.preventwin )
preventwin:defaultAccess( ULib.ACCESS_SUPERADMIN )
preventwin:addParam{ type=ULib.cmds.BoolArg, invisible=true }
preventwin:setOpposite( "ulx allowwin", {_, true} )
preventwin:help( "Toggles the prevention of winning." )
---[End]----------------------------------------------------------------------------------------


---[Round Restart]-------------------------------------------------------------------------
function ulx.roundrestart( calling_ply )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, gamemode_error, true ) else
		ULib.consoleCommand( "ttt_roundrestart" .. "\n" )
		ulx.fancyLogAdmin( calling_ply, "#A has restarted the round." )
	end
end
local restartround = ulx.command( CATEGORY_NAME, "ulx roundrestart", ulx.roundrestart )
restartround:defaultAccess( ULib.ACCESS_SUPERADMIN )
restartround:help( "Restarts the round." )
---[End]----------------------------------------------------------------------------------------