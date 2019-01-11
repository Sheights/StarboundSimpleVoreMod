--Status effects that make a target un-targetable
vsoRemoveTargetStats = {
	["vsokeepsit"]=1
	,["vsokeepsit0"]=1
	,["vsokeepsit1"]=1
	,["vsokeepsit2"]=1
	,["vsokeepsit3"]=1
	,["vsokeepsit4"]=1
	,["vsokeepsit5"]=1
	,["vsokeepsit6"]=1
	,["vsokeepsit7"]=1
}

function updateholdings()
	
	--The below FREEZES this character but...
	mcontroller.controlModifiers({movementSuppressed = true, facingSuppressed = true, runningSuppressed = true, jumpingSuppressed = true})
	mcontroller.setXVelocity( 0 );	--This helps

	if self.victimtype == "player" then
	
		local sittingon, seatid = mcontroller.anchorState();	--Useful for "lounging on"
		if (sittingon ~= owner) or (seatid ~= seatindex) then
		
			mcontroller.resetAnchorState();	--Not sure if this is needed
			world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", owner, seatindex )	--This WONT WORK unless we are ON THE GROUND???
			--mcontroller.setAnchorState( owner, seatindex )	--This COULD WORK but it errors too much.
		
			--sb.logInfo( "forcing a sit "..tostring( entity.id() ).." on "..tostring( owner ).." in seat "..tostring( seatindex ) .." was " .. tostring( seatid ).." on "..tostring( sittingon ) );
			
		end
	elseif world.isNpc( entity.id() ) then
		
		if status.isResource("stunned") then
			status.setResource("stunned", 100 )
		end
		local didit = world.callScriptedEntity( entity.id(), "npc.setLounging", owner, seatindex )
	else
		--
	end
	
end

function init()

	victim = entity.id()
	self.victimtype = entity.entityType();
	owner = effect.sourceEntity();
	seatindex = config.getParameter( "fixedSeatIndex" )
	
	if victim == owner then
		effect.expire();
	else
	
		--Remove ALL OTHER "vsokeepsit"..tostring( seatindex ) status effects FIRST. (dont care about order really)
		
		--IT kinda looks like only ONE OWNER can do this at once.
		--That owner is the "king" and is allowed to eat, anyone else isnt.
		--[[
		local statlist = status.activeUniqueStatusEffectSummary();
		sb.logInfo( "vsoforcesit: "..tostring( owner ).." "..tostring( seatindex ) );
		for k,v in pairs( statlist ) do
			local has = vsoRemoveTargetStats[ v[1] ];
			if has ~= nil then
				if has == 1 then
					sb.logInfo( "Has: ".. v[1].." "..tostring( v[2] ) );
					--Remove it? lol? Hm... Nope, someone else got you first.
					--But how do we CHANGE SEATS? (hm!)
					effect.expire();
					----return;
					--status.removeEphemeralEffect( v[1] );
				end
			end
		end
		]]--
		
		--[[
		status.removeEphemeralEffect( "vsokeepsit" );
		local ri = 0;
		while ri < 8 do
			if ri ~= seatindex then
				status.removeEphemeralEffect( "vsokeepsit"..tostring(seatindex) );
			end
			ri = ri + 1;
		end
		]]--
	
		--Hold up. possible to have a TWOfer. VSO's can't steal other people (But they CAN move your seat)
		--So you can ONLY HAVE one vsokeepsit at a time...
		--Interesting.
		--effect.sourceEntity() matches with?
		--status.stat( "vsokeepsit" )
		--vsokeepsit0
		
		mcontroller.controlModifiers({movementSuppressed = true, facingSuppressed = true, runningSuppressed = true, jumpingSuppressed = true})
		status.setPersistentEffects("movementAbility", {{stat = "activeMovementAbilities", amount = 1}})	--from tech scripts
		
		--Somehow, "lounging" requires I am NOT jumping, and on the ground now...
		if mcontroller.yVelocity() > -1 then
			mcontroller.setYVelocity( -1 )	--Must be moving down!
		end
		if not mcontroller.onGround() then	--mcontroller.groundMovement() then
			--Must PUT the victim on a surface taht triggers 'onGround' so...
			local maxsearch = -10;	--Hmmmm
			local origpos = world.entityPosition( owner );
			local hitany = world.collisionBlocksAlongLine( origpos, { origpos[1], origpos[2] + maxsearch }, { "Null", "Block", "Dynamic", "Platform" }, 1 )
			if #hitany > 0 then
				local blockPosition = hitany[1];
				local colb = mcontroller.boundBox();	--{ xmin, ymin, xmax, ymax }
				mcontroller.setPosition( { blockPosition[1], blockPosition[2] - colb[2] } )	--Hack attempt? Need to hit the ground somehow... This could push you through platforms...
			else
				--Could NOT find a place to set er down.
				--mcontroller.setPosition( origpos )	--Hack attempt? Need to hit the ground somehow...
			end
		end
		
		mcontroller.clearControls()
		mcontroller.autoClearControls( true );
		
		updateholdings();
		
	end
end

function update(dt)

	if world.entityExists( entity.id() ) and world.entityExists( owner ) then
		updateholdings();
	else
		effect.expire();
	end
end

function uninit()
	if status.isResource("stunned") then
		status.setResource("stunned", 0 )
	end
	mcontroller.autoClearControls( false );
	mcontroller.controlModifiers({ movementSuppressed = false, facingSuppressed = false, runningSuppressed = false, jumpingSuppressed = false })
	status.clearPersistentEffects( "movementAbility" )	--waht does this mean???
end
