--[=[-------------------------------------------------------------------------------------------
║                              Trouble in Terrorist Town Commands                              ║
                                    By: Skillz and Bender180                                   ║
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
local CATEGORY_NAME  = "TTT Fun"
local gamemode_error = "The current gamemode is not trouble in terrorest town"

function GamemodeCheck(calling_ply)
	if not GetConVarString("gamemode") == "terrortown" then
		ULib.tsayError( calling_ply, gamemode_error, true )
		return true
	else
		return false
	end
end

--[Helper Functions]---------------------------------------------------------------------------
--[End]----------------------------------------------------------------------------------------

--[Toggle spectator]---------------------------------------------------------------------------
--[[ulx.spec][Forces <target(s)> to and from spectator.]
@param  {[PlayerObject]} calling_ply   [The player who used the command.]
@param  {[PlayerObject]} target_plys   [The player(s) who will have the effects of the command applied to them.]
--]]
function ulx.credits( calling_ply, target_plys, amount, should_silent )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, gamemode_error, true ) else
    	for i=1, #target_plys do
    	    target_plys[ i ]:AddCredits(amount)
    	end
		ulx.fancyLogAdmin( calling_ply, true, "#A gave #T #i credits", target_plys, amount )
	end
end
local credits = ulx.command( CATEGORY_NAME, "ulx credits", ulx.credits, "!credits")
credits:addParam{ type=ULib.cmds.PlayersArg }
credits:addParam{ type=ULib.cmds.NumArg, hint="Credits", ULib.cmds.round }
credits:defaultAccess( ULib.ACCESS_SUPERADMIN )
credits:setOpposite( "ulx silent credits", {_, _, _, true}, "!scredits", true )
credits:help( "Gives the <target(s)> credits." )
--[End]----------------------------------------------------------------------------------------

--[Toggle spectator]---------------------------------------------------------------------------
--[[ulx.spec][Forces <target(s)> to and from spectator.]
@param  {[PlayerObject]} calling_ply   [The player who used the command.]
@param  {[PlayerObject]} target_plys   [The player(s) who will have the effects of the command applied to them.]
--]]
function ulx.proprechargetime( calling_ply, recharge )
	if not GetConVarString("gamemode") == "terrortown" then ULib.tsayError( calling_ply, gamemode_error, true ) else
    	
        ULib.consoleCommand( "ttt_spec_prop_rechargetime " .. recharge .. "\n" )
        
        ulx.fancyLogAdmin( calling_ply, "#A set the prop rechargetime to #i", recharge )
    end
end
local proprechargetime = ulx.command( CATEGORY_NAME, "ulx proptime", ulx.proprechargetime )
proprechargetime:addParam{ type=ULib.cmds.NumArg, min=0, max=10000, default=1, hint="Prop recharge time", ULib.cmds.optional, ULib.cmds.round }
proprechargetime:defaultAccess( ULib.ACCESS_SUPERADMIN )
proprechargetime:help( "Changes the Prop Recharge Time." )
--[End]----------------------------------------------------------------------------------------