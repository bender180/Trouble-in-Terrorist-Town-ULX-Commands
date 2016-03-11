--Terrortown settings module for ULX GUI
--Defines ttt cvar limits and ttt specific settings for the ttt gamemode.

local terrortown_settings = xlib.makepanel{ parent=xgui.null }

xlib.makelabel{ x=5, y=5, w=600, wordwrap=true, label="Trouble in Terrorist Town ULX Commands XGUI module Created by: Bender180", parent=terrortown_settings }
xlib.makelabel{ x=2, y=345, w=600, wordwrap=true, label="The settings above DO NOT SAVE when the server changes maps, is restarted or crashes. They are for easy access only", parent=terrortown_settings }

xlib.makelabel{ x=5, y=190, w=160, wordwrap=true, label="Note to sever owners: to restrict this panel allow or deny permission to xgui_gmsettings.", parent=terrortown_settings }
xlib.makelabel{ x=5, y=250, w=160, wordwrap=true, label="All settings listed are explained here: http://ttt.badking.net/config- and-commands/convars", parent=terrortown_settings }
xlib.makelabel{ x=5, y=325, w=160, wordwrap=true, label="Not all settings echo to chat.", parent=terrortown_settings }


terrortown_settings.panel = xlib.makepanel{ x=160, y=25, w=420, h=318, parent=terrortown_settings }
terrortown_settings.catList = xlib.makelistview{ x=5, y=25, w=150, h=157, parent=terrortown_settings }
terrortown_settings.catList:AddColumn( "Terrorist Town Settings" )
terrortown_settings.catList.Columns[1].DoClick = function() end

terrortown_settings.catList.OnRowSelected = function( self, LineID, Line )
	local nPanel = xgui.modules.submodule[Line:GetValue(2)].panel
	if nPanel ~= terrortown_settings.curPanel then
		nPanel:SetZPos( 0 )
		xlib.addToAnimQueue( "pnlSlide", { panel=nPanel, startx=-435, starty=0, endx=0, endy=0, setvisible=true } )
		if terrortown_settings.curPanel then
			terrortown_settings.curPanel:SetZPos( -1 )
			xlib.addToAnimQueue( terrortown_settings.curPanel.SetVisible, terrortown_settings.curPanel, false )
		end
		xlib.animQueue_start()
		terrortown_settings.curPanel = nPanel
	else
		xlib.addToAnimQueue( "pnlSlide", { panel=nPanel, startx=0, starty=0, endx=-435, endy=0, setvisible=false } )
		self:ClearSelection()
		terrortown_settings.curPanel = nil
		xlib.animQueue_start()
	end
	if nPanel.onOpen then nPanel.onOpen() end --If the panel has it, call a function when it's opened
end

--Process modular settings
function terrortown_settings.processModules()
	terrortown_settings.catList:Clear()
	for i, module in ipairs( xgui.modules.submodule ) do
		if module.mtype == "terrortown_settings" and ( not module.access or LocalPlayer():query( module.access ) ) then
			local w,h = module.panel:GetSize()
			if w == h and h == 0 then module.panel:SetSize( 275, 322 ) end
			
			if module.panel.scroll then --For DListLayouts
				module.panel.scroll.panel = module.panel
				module.panel = module.panel.scroll
			end
			module.panel:SetParent( terrortown_settings.panel )
			
			local line = terrortown_settings.catList:AddLine( module.name, i )
			if ( module.panel == terrortown_settings.curPanel ) then
				terrortown_settings.curPanel = nil
				terrortown_settings.catList:SelectItem( line )
			else
				module.panel:SetVisible( false )
			end
		end
	end
	terrortown_settings.catList:SortByColumn( 1, false )
end
terrortown_settings.processModules()

xgui.hookEvent( "onProcessModules", nil, terrortown_settings.processModules )
xgui.addModule( "TTT", terrortown_settings, "icon16/ttt.png", "xgui_gmsettings" )

--------------------Round structure Module--------------------
local rspnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

--Preparation and post-round
local rspapclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
rspapclp:SetSize( 390, 70 )
rspapclp:SetExpanded( 1 )
rspapclp:SetLabel( "Preparation and post-round" )

local rspaplst = vgui.Create( "DPanelList", rspapclp )
rspaplst:SetPos( 5, 25 )
rspaplst:SetSize( 390, 70 )
rspaplst:SetSpacing( 5 )
   
local prept = xlib.makeslider{ label="ttt_preptime_seconds (def. 30)", min=1, max=120, repconvar="rep_ttt_preptime_seconds", parent=rspaplst }
rspaplst:AddItem( prept )

local fprept = xlib.makeslider{ label="ttt_firstpreptime (def. 60)", min=1, max=120, repconvar="rep_ttt_firstpreptime", parent=rspaplst }
rspaplst:AddItem( fprept )

local pstt = xlib.makeslider{ label="ttt_posttime_seconds (def. 30)", min=1, max=120, repconvar="rep_ttt_posttime_seconds", parent=rspaplst }
rspaplst:AddItem( pstt )

--Round length
local rsrlclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
rsrlclp:SetSize( 390, 90)
rsrlclp:SetExpanded( 0 )
rsrlclp:SetLabel( "Round length" )

local rsrllst = vgui.Create( "DPanelList", rsrlclp )
rsrllst:SetPos( 5, 25 )
rsrllst:SetSize( 390, 90 )
rsrllst:SetSpacing( 5 )

local hstmd = xlib.makecheckbox{label="ttt_haste", repconvar="rep_ttt_haste", parent=rsrllst }
rsrllst:AddItem( hstmd )

local hstsm = xlib.makeslider{label="ttt_haste_starting_minutes (def. 5)", min=1, max=60, repconvar="rep_ttt_haste_starting_minutes", parent=rsrllst}
rsrllst:AddItem( hstsm )

local hstmpd = xlib.makeslider{label="ttt_haste_minutes_per_death (def. 0.5)", min=0.1, max=9, decimal=1, repconvar="rep_ttt_haste_minutes_per_death", parent=rsrllst}
rsrllst:AddItem( hstmpd )

local rtm = xlib.makeslider{label="ttt_roundtime_minutes (def. 10)", min=1, max=60, repconvar="rep_ttt_roundtime_minutes", parent=rsrllst}
rsrllst:AddItem( rtm )

--Map switching and voting
local msavclp = vgui.Create( "DCollapsibleCategory", rspnl ) 
msavclp:SetSize( 390, 95 )
msavclp:SetExpanded( 0 )
msavclp:SetLabel( "Map switching and voting" )

local msavlst = vgui.Create( "DPanelList", msavclp )
msavlst:SetPos( 5, 25 )
msavlst:SetSize( 390, 95 )
msavlst:SetSpacing( 5 )

local rndl = xlib.makeslider{label="ttt_round_limit (def. 6)", min=1, max=100, repconvar="rep_ttt_round_limit", parent=msavlst}
msavlst:AddItem( rndl )

local rndtlm = xlib.makeslider{label="ttt_time_limit_minutes (def. 75)", min=1, max=150, repconvar="rep_ttt_time_limit_minutes", parent=msavlst}
msavlst:AddItem( rndtlm )

local rndawm = xlib.makecheckbox{label="ttt_always_use_mapcycle (def. 0)", repconvar="rep_ttt_always_use_mapcycle", parent=msavlst }
msavlst:AddItem( rndawm )

local rndawmtxt = xlib.makelabel{ wordwrap=true, label="This does nothing but since its included in TTT it's here.", parent=msavlst }
msavlst:AddItem( rndawmtxt )

xgui.hookEvent( "onProcessModules", nil, rspnl.processModules )
xgui.addSubModule( "Round structure", rspnl, nil, "terrortown_settings" )

--------------------Gameplay Module--------------------
local gppnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

--Traitor and Detective counts
local gptdcclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
gptdcclp:SetSize( 390, 100 )
gptdcclp:SetExpanded( 1 )
gptdcclp:SetLabel( "Traitor and Detective counts" )

local gptdlst = vgui.Create( "DPanelList", gptdcclp )
gptdlst:SetPos( 5, 25 )
gptdlst:SetSize( 390, 100 )
gptdlst:SetSpacing( 5 )
   
local tpercet = xlib.makeslider{ label="ttt_traitor_pct (def. 0.25)", min=0.01, max=2, decimal=2, repconvar="rep_ttt_traitor_pct", parent=gptdlst}
gptdlst:AddItem( tpercet )

local tmax = xlib.makeslider{ label="ttt_traitor_max (def. 32)", min=1, max=80, repconvar="rep_ttt_traitor_max", parent=gptdlst }
gptdlst:AddItem( tmax )

local dpercet = xlib.makeslider{ label="ttt_detective_pct (def. 0.13)", min=0.01, max=2, decimal=2, repconvar="rep_ttt_detective_pct", parent=gptdlst }
gptdlst:AddItem( dpercet )

local dmax = xlib.makeslider{ label="ttt_detective_max (def. 32)", min=1, max=80, repconvar="rep_ttt_detective_max", parent=gptdlst }
gptdlst:AddItem( dmax )

local dmp = xlib.makeslider{ label="ttt_detective_min_players (def. 10)", min=1, max=50, repconvar="rep_ttt_detective_min_players", parent=gptdlst }
gptdlst:AddItem( dmp )

local dkm = xlib.makeslider{ label="ttt_detective_karma_min (def. 600)", min=1, max=1000, repconvar="rep_ttt_detective_karma_min", parent=gptdlst }
gptdlst:AddItem( dkm )

--DNA
local gpdnaclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
gpdnaclp:SetSize( 390, 45 )
gpdnaclp:SetExpanded( 0 )
gpdnaclp:SetLabel( "DNA" )

local gpdnalst = vgui.Create( "DPanelList", gpdnaclp )
gpdnalst:SetPos( 5, 25 )
gpdnalst:SetSize( 390, 45 )
gpdnalst:SetSpacing( 5 )

local dnarange = xlib.makeslider{ label="ttt_killer_dna_range (def. 550)", min=100, max=1000, repconvar="rep_ttt_killer_dna_range", parent=gpdnalst }
gpdnalst:AddItem( dnarange )

local dnakbt = xlib.makeslider{ label="ttt_killer_dna_basetime (def. 100)", min=10, max=200, repconvar="rep_ttt_killer_dna_basetime", parent=gpdnalst }
gpdnalst:AddItem( dnakbt )

--Voicechat battery
local gpvcbclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
gpvcbclp:SetSize( 390, 65)
gpvcbclp:SetExpanded( 0 )
gpvcbclp:SetLabel( "Voicechat battery" )

local gpvcblst = vgui.Create( "DPanelList", gpvcbclp )
gpvcblst:SetPos( 5, 25 )
gpvcblst:SetSize( 390, 65 )
gpvcblst:SetSpacing( 5 )

local gpevd = xlib.makecheckbox{label="ttt_voice_drain (def. 0)", repconvar="rep_ttt_voice_drain", parent=gpvcblst }
gpvcblst:AddItem( gpevd )

local gpvdn = xlib.makeslider{ label="ttt_voice_drain_normal (def. 0.2)", min=0.1, max=1, decimal=1, repconvar="rep_ttt_voice_drain_normal", parent=gpvcblst }
gpvcblst:AddItem( gpvdn )

local gpvda = xlib.makeslider{ label="ttt_voice_drain_admin (def. 0.05)", min=0.01, max=1, decimal=2, repconvar="rep_ttt_voice_drain_admin", parent=gpvcblst }
gpvcblst:AddItem( gpvda )

local gpvdr = xlib.makeslider{ label="ttt_voice_drain_recharge (def. 0.05)", min=0.01, max=1, decimal=2, repconvar="rep_ttt_voice_drain_recharge", parent=gpvcblst }
gpvcblst:AddItem( gpvdr )

--Other gameplay settings
local gpogsclp = vgui.Create( "DCollapsibleCategory", gppnl ) 
gpogsclp:SetSize( 390, 200)
gpogsclp:SetExpanded( 0 )
gpogsclp:SetLabel( "Other gameplay settings" )

local gpogslst = vgui.Create( "DPanelList", gpogsclp )
gpogslst:SetPos( 5, 25 )
gpogslst:SetSize( 390, 200 )
gpogslst:SetSpacing( 5 )

local gpminply = xlib.makeslider{label="ttt_minimum_players (def. 2)", min=1, max=10, repconvar="rep_ttt_minimum_players", parent=gpogslst }
gpogslst:AddItem( gpminply )

local gpprdm = xlib.makecheckbox{ label="ttt_postround_dm (def. 0)", repconvar="rep_ttt_postround_dm", parent=gpogslst }
gpogslst:AddItem( gpprdm )

local gpds = xlib.makecheckbox{ label="ttt_dyingshot (def. 0)", repconvar="rep_ttt_dyingshot", parent=gpogslst }
gpogslst:AddItem( gpds )

local gpnntdp = xlib.makecheckbox{ label="ttt_no_nade_throw_during_prep (def. 0)", repconvar="rep_ttt_no_nade_throw_during_prep", parent=gpogslst }
gpogslst:AddItem( gpnntdp )

local gpwc = xlib.makecheckbox{ label="ttt_weapon_carrying (def. 1)", repconvar="rep_ttt_weapon_carrying", parent=gpogslst }
gpogslst:AddItem( gpwc )

local gpwcr = xlib.makeslider{label="ttt_weapon_carrying_range (def. 50)", min=10, max=100, repconvar="rep_ttt_weapon_carrying_range", parent=gpogslst }
gpogslst:AddItem( gpwcr )

local gpttf = xlib.makecheckbox{ label="ttt_teleport_telefrags (def. 0)", repconvar="rep_ttt_teleport_telefrags", parent=gpogslst }
gpogslst:AddItem( gpttf )

local gprdp = xlib.makecheckbox{ label="ttt_ragdoll_pinning (def. 1)", repconvar="rep_ttt_ragdoll_pinning", parent=gpogslst }
gpogslst:AddItem( gprdp )

local gprdpi = xlib.makecheckbox{ label="ttt_ragdoll_pinning_innocents (def. 0)", repconvar="rep_ttt_ragdoll_pinning_innocents", parent=gpogslst }
gpogslst:AddItem( gprdpi )

xgui.hookEvent( "onProcessModules", nil, gppnl.processModules )
xgui.addSubModule( "Gameplay", gppnl, nil, "terrortown_settings" )

--------------------Karma Module--------------------
local krmpnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local krmclp = vgui.Create( "DCollapsibleCategory", krmpnl ) 
krmclp:SetSize( 390, 400)
krmclp:SetExpanded( 1 )
krmclp:SetLabel( "Karma" )

local krmlst = vgui.Create( "DPanelList", krmclp )
krmlst:SetPos( 5, 25 )
krmlst:SetSize( 390, 400 )
krmlst:SetSpacing( 5 )

local krmekrm = xlib.makecheckbox{label="ttt_karma", repconvar="rep_ttt_karma", parent=krmlst }
krmlst:AddItem( krmekrm )

local krmeskrm = xlib.makecheckbox{ label="ttt_karma_strict", repconvar="rep_ttt_karma_strict", parent=krmlst }
krmlst:AddItem( krmeskrm )

local krms = xlib.makeslider{ label="ttt_karma_starting (def. 1000)", min=500, max=2000, repconvar="rep_ttt_karma_starting", parent=krmlst }
krmlst:AddItem( krms )

local krmmx = xlib.makeslider{ label="ttt_karma_max (def. 1000)", min=500, max=2000, repconvar="rep_ttt_karma_max", parent=krmlst }
krmlst:AddItem( krmmx )

local krmr = xlib.makeslider{ label="ttt_karma_ratio (def. 0.001)", min=0.001, max=0.009, decimal=3, repconvar="rep_ttt_karma_ratio", parent=krmlst }
krmlst:AddItem( krmr )

local krmkp = xlib.makeslider{ label="ttt_karma_kill_penalty (def. 15)", min=1, max=30, repconvar="rep_ttt_karma_kill_penalty", parent=krmlst }
krmlst:AddItem( krmkp )

local krmri = xlib.makeslider{ label="ttt_karma_round_increment (def. 5)", min=1, max=30, repconvar="rep_ttt_karma_round_increment", parent=krmlst }
krmlst:AddItem( krmri )

local krmcb = xlib.makeslider{ label="ttt_karma_clean_bonus (def. 30)", min=10, max=100, repconvar="rep_ttt_karma_clean_bonus", parent=krmlst }
krmlst:AddItem( krmcb )

local krmtdmgr = xlib.makeslider{ label="ttt_karma_traitordmg_ratio (def. 0.0003)", min=0.0001, max=0.001, decimal=4, repconvar="rep_ttt_karma_traitordmg_ratio", parent=krmlst }
krmlst:AddItem( krmtdmgr )

local krmtkb = xlib.makeslider{ label="ttt_karma_traitorkill_bonus (def. 40)", min=10, max=100, repconvar="rep_ttt_karma_traitorkill_bonus", parent=krmlst }
krmlst:AddItem( krmtkb )

local krmlak = xlib.makecheckbox{label="ttt_karma_low_autokick (def. 1)", repconvar="rep_ttt_karma_low_autokick", parent=krmlst }
krmlst:AddItem( krmlak)

local krmla = xlib.makeslider{ label="ttt_karma_low_amount (def. 450)", min=100, max=1000, repconvar="rep_ttt_karma_low_amount", parent=krmlst }
krmlst:AddItem( krmla )

local krmlab = xlib.makecheckbox{label="ttt_karma_low_ban (def. 1)", repconvar="rep_ttt_karma_low_ban", parent=krmlst }
krmlst:AddItem( krmlab)

local krmlbm = xlib.makeslider{ label="ttt_karma_low_ban_minutes (def. 60)", min=10, max=100, repconvar="rep_ttt_karma_low_ban_minutes", parent=krmlst }
krmlst:AddItem( krmlbm )

local krmpre = xlib.makecheckbox{label="ttt_karma_persist (def. 0)", repconvar="rep_ttt_karma_persist", parent=krmlst }
krmlst:AddItem( krmpre)

local krmdbs = xlib.makecheckbox{label="ttt_karma_debugspam (def. 0)", repconvar="rep_ttt_karma_debugspam", parent=krmlst }
krmlst:AddItem( krmdbs)

local krmch = xlib.makeslider{ label="ttt_karma_clean_half (def. 0.25)", min=0.01, max=0.9, decimal=2, repconvar="rep_ttt_karma_clean_half", parent=krmlst }
krmlst:AddItem( krmch )

xgui.hookEvent( "onProcessModules", nil, krmpnl.processModules )
xgui.addSubModule( "Karma", krmpnl, nil, "terrortown_settings" )

--------------------Map-related Module--------------------
local mprpnl = xlib.makepanel{ w=415, h=318, parent=xgui.null }

xlib.makecheckbox{x=5, y=5, label="ttt_use_weapon_spawn_scripts (def. 1)", repconvar="rep_ttt_use_weapon_spawn_scripts", parent=mprpnl }

xgui.hookEvent( "onProcessModules", nil, mprpnl.processModules )
xgui.addSubModule( "Map-related", mprpnl, nil, "terrortown_settings" )

--------------------Equipment credits Module--------------------
local ecpnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

--Traitor credits
local ectcclp = vgui.Create( "DCollapsibleCategory", ecpnl ) 
ectcclp:SetSize( 390, 120)
ectcclp:SetExpanded( 1 )
ectcclp:SetLabel( "Traitor credits" )

local ectclst = vgui.Create( "DPanelList", ectcclp )
ectclst:SetPos( 5, 25 )
ectclst:SetSize( 390, 120 )
ectclst:SetSpacing( 5 )

local ectccs = xlib.makeslider{ label="ttt_credits_starting (def. 2)", min=0, max=10, repconvar="rep_ttt_credits_starting", parent=ectclst }
ectclst:AddItem( ectccs )

local ectcap = xlib.makeslider{ label="ttt_credits_award_pct (def. 0.35)", min=0.01, max=0.9, decimal=2, repconvar="rep_ttt_credits_award_pct", parent=krmlst }
ectclst:AddItem( ectcap )

local ectcas = xlib.makeslider{ label="ttt_credits_award_size (def. 1)", min=0, max=5, repconvar="rep_ttt_credits_award_size", parent=ectclst }
ectclst:AddItem( ectcas )

local ectcar = xlib.makeslider{ label="ttt_credits_award_repeat (def. 1)", min=0, max=5, repconvar="rep_ttt_credits_award_repeat", parent=ectclst }
ectclst:AddItem( ectcar )

local ectcdk = xlib.makeslider{ label="ttt_credits_detectivekill (def. 1)", min=0, max=5, repconvar="rep_ttt_credits_detectivekill", parent=ectclst }
ectclst:AddItem( ectcdk )

--Detective credits
local ecdcclp = vgui.Create( "DCollapsibleCategory", ecpnl ) 
ecdcclp:SetSize( 390, 90)
ecdcclp:SetExpanded( 0 )
ecdcclp:SetLabel( "Detective credits" )

local ecdclst = vgui.Create( "DPanelList", ecdcclp )
ecdclst:SetPos( 5, 25 )
ecdclst:SetSize( 390, 90 )
ecdclst:SetSpacing( 5 )

local ecdccs = xlib.makeslider{ label="ttt_det_credits_starting (def. 1)", min=0, max=10, repconvar="rep_ttt_det_credits_starting", parent=ecdclst }
ecdclst:AddItem( ecdccs )

local ecdctk = xlib.makeslider{ label="ttt_det_credits_traitorkill (def. 0)", min=0, max=10, repconvar="rep_ttt_det_credits_traitorkill", parent=ecdclst }
ecdclst:AddItem( ecdctk )

local ecdctd = xlib.makeslider{ label="ttt_det_credits_traitordead (def. 1)", min=0, max=10, repconvar="rep_ttt_det_credits_traitordead", parent=ecdclst }
ecdclst:AddItem( ecdctd )

xgui.hookEvent( "onProcessModules", nil, ecpnl.processModules )
xgui.addSubModule( "Equipment credits", ecpnl, nil, "terrortown_settings" )

--------------------Prop possession Module--------------------
local pppnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local ppclp = vgui.Create( "DCollapsibleCategory", pppnl ) 
ppclp:SetSize( 390, 120)
ppclp:SetExpanded( 1 )
ppclp:SetLabel( "Prop possession" )

local pplst = vgui.Create( "DPanelList", ppclp )
pplst:SetPos( 5, 25 )
pplst:SetSize( 390, 120 )
pplst:SetSpacing( 5 )

local ppspc = xlib.makecheckbox{label="ttt_spec_prop_control  (def. 1)", repconvar="rep_ttt_spec_prop_control", parent=pplst }
pplst:AddItem( ppspc )

local ppspb = xlib.makeslider{ label="ttt_spec_prop_base (def. 8)", min=0, max=50, repconvar="rep_ttt_spec_prop_base", parent=pplst }
pplst:AddItem( ppspb )

local ppspmp = xlib.makeslider{ label="ttt_spec_prop_maxpenalty (def. -6)", min=-50, max=0, repconvar="rep_ttt_spec_prop_maxpenalty", parent=pplst }
pplst:AddItem( ppspmp )

local ppspmb = xlib.makeslider{ label="ttt_spec_prop_maxbonus (def. 16)", min=0, max=50, repconvar="rep_ttt_spec_prop_maxbonus", parent=pplst }
pplst:AddItem( ppspmb )

local ppspf = xlib.makeslider{ label="ttt_spec_prop_force (def. 110)", min=50, max=300, repconvar="rep_ttt_spec_prop_force", parent=pplst }
pplst:AddItem( ppspf )

local ppprt = xlib.makeslider{ label="ttt_spec_prop_rechargetime (def. 1)", min=0, max=10, repconvar="rep_ttt_spec_prop_rechargetime", parent=pplst }
pplst:AddItem( ppprt )

xgui.hookEvent( "onProcessModules", nil, pppnl.processModules )
xgui.addSubModule( "Prop possession", pppnl, nil, "terrortown_settings" )

--------------------Admin-related Module--------------------
local arpnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local arclp = vgui.Create( "DCollapsibleCategory", arpnl ) 
arclp:SetSize( 390, 120)
arclp:SetExpanded( 1 )
arclp:SetLabel( "Admin-related" )

local arlst = vgui.Create( "DPanelList", arclp )
arlst:SetPos( 5, 25 )
arlst:SetSize( 390, 120 )
arlst:SetSpacing( 5 )

local aril = xlib.makeslider{label="ttt_idle_limit (def. 180)", min=50, max=300, repconvar="rep_ttt_idle_limit", parent=arlst }
arlst:AddItem( aril )

local arnck = xlib.makecheckbox{label="ttt_namechange_kick (def. 1)", repconvar="rep_ttt_namechange_kick", parent=arlst }
arlst:AddItem( arnck )

local arncbt = xlib.makeslider{label="ttt_namechange_bantime (def. 10)", min=0, max=60, repconvar="rep_ttt_namechange_bantime", parent=arlst }
arlst:AddItem( arncbt )

xgui.hookEvent( "onProcessModules", nil, arpnl.processModules )
xgui.addSubModule( "Admin-related", arpnl, nil, "terrortown_settings" )

--------------------Miscellaneous Module--------------------
local miscpnl = xlib.makelistlayout{ w=415, h=318, parent=xgui.null }

local miscclp = vgui.Create( "DCollapsibleCategory", miscpnl ) 
miscclp:SetSize( 390, 120)
miscclp:SetExpanded( 1 )
miscclp:SetLabel( "Miscellaneous" )

local misclst = vgui.Create( "DPanelList", miscclp)
misclst:SetPos( 5, 25 )
misclst:SetSize( 390, 120 )
misclst:SetSpacing( 5 )

local miscdh = xlib.makecheckbox{label="ttt_detective_hats (def. 0)", repconvar="rep_ttt_detective_hats", parent=misclst }
misclst:AddItem( miscdh )

local miscpcm = xlib.makeslider{label="ttt_playercolor_mode (def. 1)", min=0, max=3, repconvar="rep_ttt_playercolor_mode", parent=misclst }
misclst:AddItem( miscpcm )

local miscrc = xlib.makecheckbox{label="ttt_ragdoll_collide (def. 0)", repconvar="rep_ttt_ragdoll_collide", parent=misclst }
misclst:AddItem( miscrc )

local miscbs = xlib.makecheckbox{label="ttt_bots_are_spectators (def. 0)", repconvar="rep_ttt_bots_are_spectators", parent=misclst }
misclst:AddItem( miscbs )

local miscdm = xlib.makecheckbox{label="ttt_debug_preventwin (def. 0)", repconvar="rep_ttt_debug_preventwin", parent=misclst }
misclst:AddItem( miscdm )

local misclv = xlib.makecheckbox{label="ttt_locational_voice (def. 0)", repconvar="rep_ttt_locational_voice", parent=misclst }
misclst:AddItem( misclv )

local miscdj = xlib.makecheckbox{label="ttt_allow_discomb_jump (def. 0)", repconvar="rep_ttt_allow_discomb_jump", parent=misclst }
misclst:AddItem( miscdj )

local miscswi = xlib.makeslider{label="ttt_spawn_wave_interval (def. 0)", min=0, max=30, repconvar="rep_ttt_spawn_wave_interval", parent=misclst }
misclst:AddItem( miscswi )

xgui.hookEvent( "onProcessModules", nil, miscpnl.processModules )
xgui.addSubModule( "Miscellaneous", miscpnl, nil, "terrortown_settings" )