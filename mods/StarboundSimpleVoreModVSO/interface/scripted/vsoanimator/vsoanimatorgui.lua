
function init( )
	--self.activateItem = config.getParameter("activateItem")
	--THIS HAS A PLAYER CONTEXT (bitch)
	--does NOT have entity context. or message context.
	--

	targetId = config.getParameter("vsoOwnerID");
	playerId = config.getParameter("vsoInteractId")
	
	player.lounge( targetId )	--Hm! Dont care? Or do I? This lounge ignores multiple sit positions???
	
	--This is to rolling update variables sicne we can't recieve messages, but we CAN RpcPromise get values back.
	rollingUpdate = 0;
	rollingUpdateLoopMin = 3;
	rollingUpdateRPC = nil;
	rollingUpdateRPCWait = 0;
	rollingUpdateRPCCalls = {
		animationList = "vsoAnimatorPanelGet"
		,playerLists = "vsoAnimatorPanelGet"
		,transformGroups = "vsoAnimatorPanelGet"
		,current = "vsoAnimatorPanelGet"
	}
	rollingUpdateRPCList = { "animationList", "playerLists", "current", "transformGroups" }
	rollingUpdateRPCResult = {}
	for k,v in pairs( rollingUpdateRPCCalls ) do
		--table.insert( rollingUpdateRPCList, k )	--if you could keep order...
		rollingUpdateRPCResult[ k ] = nil;	--Or somehow SORT this list...
	end
	
	world.sendEntityMessage( targetId, "vsoAnimatorPanelInit", targetId, playerId )
	
end

function tostringNdecimals( v, N )
	local s = tostring( v )
	local i = string.find(s, ".")    -- find 'next' newline
	if i ~= nil then
		if i > 0 then
			s = string.sub(s, 0, i + N )
		end
	end
	return s;
end

function tostring0decimals( v ) return tostringNdecimals( v, 0 ); end
function tostring1decimals( v ) return tostringNdecimals( v, 1 ); end
function tostring2decimals( v ) return tostringNdecimals( v, 2 ); end
function tostring3decimals( v ) return tostringNdecimals( v, 5 ); end

function update(dt)

	if world.entityExists( targetId ) then
	
		if rollingUpdateRPC ~= nil and rollingUpdateRPC:finished() then
			
			local key = rollingUpdateRPCList[ rollingUpdate ]
			
			local res = rollingUpdateRPC:result()	--Uh!
			
			if res == nil then
				--sb.logInfo( "FAILED : " .. key );
			else
				rollingUpdateRPCResult[ key ] = res;
			end
			
			rollingUpdateRPC = nil;
		else
			rollingUpdateRPCWait = rollingUpdateRPCWait + dt;
			
			if rollingUpdateRPC == nil or rollingUpdateRPCWait > 1.0 then
			
				rollingUpdate = rollingUpdate + 1;
				if rollingUpdate > #rollingUpdateRPCList then 
					rollingUpdate = rollingUpdateLoopMin
				end
				
				--But we MUST do these first. NO matter what.
				local fromdw = 1;
				while fromdw < rollingUpdateLoopMin do
					if rollingUpdateRPCResult[ rollingUpdateRPCList[ fromdw ] ] == nil then
						rollingUpdate = fromdw;
						break;
					end
					fromdw = fromdw + 1
				end
				
				local key = rollingUpdateRPCList[ rollingUpdate ]
				rollingUpdateRPC = world.sendEntityMessage( targetId, rollingUpdateRPCCalls[ key ], key )
				rollingUpdateRPCWait = 0;
			end
		end
		
		if
			rollingUpdateRPCResult.playerLists ~= nil
			and rollingUpdateRPCResult.animationList ~= nil
			and rollingUpdateRPCResult.current ~= nil 
		then
		
			--AA.allAnimationsList[ AA.current.animationIndex ].state
			--local animashun = rollingUpdateRPCResult.animationList[ rollingUpdateRPCResult.current.animationIndex ];
			
			local currstate = rollingUpdateRPCResult.animationList.allStatesNameList[ rollingUpdateRPCResult.current.stateNameIndex ]
			local curranim = rollingUpdateRPCResult.animationList.allStatesAnimNameLists[ currstate ][ rollingUpdateRPCResult.current.stateAnimIndex[ currstate ] ]
			local animashun = rollingUpdateRPCResult.animationList.allStates[ currstate ][ curranim ];
			
			if rollingUpdateRPCResult.transformGroups ~= nil then
			
				local TT = rollingUpdateRPCResult.transformGroups[ rollingUpdateRPCResult.current.transformGroupIndex ]
		
				widget.setText( "valueTrans", tostring( TT.name ) )
				widget.setText( "valueX", tostring3decimals( TT.pos[1] ) )
				widget.setText( "valueY", tostring3decimals( TT.pos[2] ) )
				widget.setText( "valueR", tostring3decimals( TT.rot * 57.295779513082320876798154814105 ) )
				widget.setText( "valueSX", tostring3decimals( TT.scale[1] ) )
				widget.setText( "valueSY", tostring3decimals( TT.scale[2] ) )
				widget.setChecked( "checkFx", TT.scale[1] < 0 )
				widget.setChecked( "checkFy", TT.scale[2] < 0 )
				
			else
				--widget.setText( "textTTname", "T: ".."NO TRANSFORM GROUPS" )
			end
			
			--local adecor = "["..tostring3decimals( rollingUpdateRPCResult.current.animTime ).."/"..tostring3decimals( animashun.cycle ).."] @"..tostring(rollingUpdateRPCResult.current.lastAnimRate)
			--widget.setText( "valueAnimTime", tostring3decimals( rollingUpdateRPCResult.current.animTime ).."/"..tostring3decimals( animashun.cycle ) )
			
			local currframe = 0;
			if animashun.frames ~= nil and animashun.cycle ~= nil then
				if animashun.cycle ~= 0 then
					currframe = math.floor( animashun.frames * (rollingUpdateRPCResult.current.stateAnimTime[ currstate ] / animashun.cycle) );
				end
			end
			
			widget.setText( "valueAnimTime", tostring3decimals( rollingUpdateRPCResult.current.stateAnimTime[ currstate ] ).."/"..tostring3decimals( animashun.cycle ).." f"..tostring(currframe) )
			
			widget.setText( "valueAnimSpeed", tostring(rollingUpdateRPCResult.current.lastAnimRate) )
			
			widget.setText( "valueState", tostring( currstate ) )
			widget.setText( "valueAnim", tostring( curranim ) )
			
			--Hm!
			--"valueSeat"	-- Which currently selected seat am I editing for the victim
				--AA.allSeatsNameList[ AA.current.seatIndex ] ?
			
			local currseatname = rollingUpdateRPCResult.animationList.allSeatsNameList[ rollingUpdateRPCResult.current.seatIndex ]
			widget.setText( "valueSeat", tostring( currseatname ) )
			
			local currseatdexes = rollingUpdateRPCResult.current.seatAnimData[ currseatname ]
			widget.setText( "valueStand", tostring( rollingUpdateRPCResult.playerLists.stands[ currseatdexes.standIndex ] ) )
			widget.setText( "valueDance", tostring( rollingUpdateRPCResult.playerLists.dances[ currseatdexes.danceIndex ] ) )
			widget.setText( "valueEmote", tostring( rollingUpdateRPCResult.playerLists.emotes[ currseatdexes.emoteIndex ] ) )
			
			--widget.setText( "valueStand", rollingUpdateRPCResult.playerLists.stands[ rollingUpdateRPCResult.current.playerStandIndex ] )
			--widget.setText( "valueDance", tostring( rollingUpdateRPCResult.playerLists.dances[ rollingUpdateRPCResult.current.playerDanceIndex ] ) )
			--widget.setText( "valueEmote", tostring( rollingUpdateRPCResult.playerLists.emotes[ rollingUpdateRPCResult.current.playerEmoteIndex ] ) )
			
		else
			--	widget.setText( "textAnimname", "A: ".."NO CURRENT" )
		end
		
			
	else
		pane.dismiss()
	end
end

function respond( k, v1, v2 )
	--sb.logInfo( k.." "..tostring( v1 ).." "..tostring( v2 ) );
	world.sendEntityMessage( targetId, "vsoAnimatorPanelControl", k, v1, v2 )
end

function buttonPress( arg1 ) respond( "button", arg1, arg2 ) end

function checkFx( arg1, arg2 ) respond( "checkFx", arg1, arg2 ) end
function checkFy( arg1, arg2 ) respond( "checkFy", arg1, arg2 ) end

spinSeat = {}
spinStandPosition = {}
spinDance = {}
spinEmote = {}
spinState = {}
spinAnim = {}
spinTransform = {}
spinX = {}
spinY = {}
spinR = {}
spinSX = {}
spinSY = {}

function spinSeat.up (arg1, arg2) respond( "spinSeat", 1, arg1, arg2 ) end 
function spinSeat.down (arg1, arg2) respond( "spinSeat", -1, arg1, arg2 ) end
function spinStandPosition.up (arg1, arg2) respond( "spinStandPosition", 1, arg1, arg2 ) end
function spinStandPosition.down (arg1, arg2) respond( "spinStandPosition", -1, arg1, arg2 ) end
function spinDance.up(arg1, arg2) respond( "spinDance", 1, arg1, arg2 ) end
function spinDance.down(arg1, arg2) respond( "spinDance", -1, arg1, arg2 ) end
function spinEmote.up (arg1, arg2) respond( "spinEmote", 1, arg1, arg2 ) end
function spinEmote.down (arg1, arg2) respond( "spinEmote", -1, arg1, arg2 ) end
function spinState.up (arg1, arg2) respond( "spinState", 1, arg1, arg2 ) end
function spinState.down (arg1, arg2) respond( "spinState", -1, arg1, arg2 ) end
function spinAnim.up (arg1, arg2) respond( "spinAnim", 1, arg1, arg2 ) end
function spinAnim.down (arg1, arg2) respond( "spinAnim", -1, arg1, arg2 ) end
function spinTransform.up (arg1, arg2) respond( "spinTransform", 1, arg1, arg2 ) end
function spinTransform.down (arg1, arg2) respond( "spinTransform", -1, arg1, arg2 ) end
function spinX.up (arg1, arg2) respond( "spinX", 1, arg1, arg2 ) end
function spinX.down (arg1, arg2) respond( "spinX", -1, arg1, arg2 ) end
function spinY.up (arg1, arg2) respond( "spinY", 1, arg1, arg2 ) end
function spinY.down (arg1, arg2) respond( "spinY", -1, arg1, arg2 ) end
function spinR.up (arg1, arg2) respond( "spinR", 1, arg1, arg2 ) end
function spinR.down (arg1, arg2) respond( "spinR", -1, arg1, arg2 ) end
function spinSX.up (arg1, arg2) respond( "spinSX", 1, arg1, arg2 ) end
function spinSX.down (arg1, arg2) respond( "spinSX", -1, arg1, arg2 ) end
function spinSY.up (arg1, arg2) respond( "spinSY", 1, arg1, arg2 ) end
function spinSY.down (arg1, arg2) respond( "spinSY", -1, arg1, arg2 ) end
