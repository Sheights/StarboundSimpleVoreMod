
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

function tostring3decimals( v )
	local s = tostring( v )
	local i = string.find(s, ".")    -- find 'next' newline
	if i ~= nil then
		s = string.sub(s, 0, i + 5 )
	end
	return s;
end

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
			local animashun = rollingUpdateRPCResult.animationList[ rollingUpdateRPCResult.current.animationIndex ];
			
			if rollingUpdateRPCResult.transformGroups ~= nil then
			
				local TT = rollingUpdateRPCResult.transformGroups[ rollingUpdateRPCResult.current.transformGroupIndex ]
		
				widget.setText( "textTTname", "T: "..tostring( TT.name ) )
				widget.setText( "textX", "x: "..tostring3decimals( TT.pos[1] ) )
				widget.setText( "textY", "y: "..tostring3decimals( TT.pos[2] ) )
				widget.setText( "textR", "r: "..tostring3decimals( TT.rot * 57.295779513082320876798154814105 ) )
				widget.setText( "textF", "f: "..tostring3decimals( TT.scale[1] ) )
			else
				widget.setText( "textTTname", "T: ".."NO TRANSFORM GROUPS" )
			end
			
			local adecor = "["..tostring3decimals( rollingUpdateRPCResult.current.animTime ).."/"..tostring3decimals( animashun.cycle ).."] @"..tostring(rollingUpdateRPCResult.current.lastAnimRate)
			widget.setText( "textAnimname", "A: "..tostring( animashun.name ).." "..adecor )
			
			widget.setText( "textPstand", "Stand: "..rollingUpdateRPCResult.playerLists.stands[ rollingUpdateRPCResult.current.playerStandIndex ] )
			widget.setText( "textPemote", "Dance: "..tostring( rollingUpdateRPCResult.playerLists.dances[ rollingUpdateRPCResult.current.playerDanceIndex ] ) )
			widget.setText( "textPdance", "Emote: "..tostring( rollingUpdateRPCResult.playerLists.emotes[ rollingUpdateRPCResult.current.playerEmoteIndex ] ) )
			
			
		else
			--	widget.setText( "textAnimname", "A: ".."NO CURRENT" )
		end
		
			
	else
		pane.dismiss()
	end
end

function cbkTestButton() 
	world.sendEntityMessage( targetId, "vsoAnimatorPanelControl", "cbkTestButton", 1 )
end
function cbkTestButton2() 
	world.sendEntityMessage( targetId, "vsoAnimatorPanelControl", "cbkTestButton2", 1 )
end
function cbkTestButton3() 
	world.sendEntityMessage( targetId, "vsoAnimatorPanelControl", "cbkTestButton3", 1 )
end
