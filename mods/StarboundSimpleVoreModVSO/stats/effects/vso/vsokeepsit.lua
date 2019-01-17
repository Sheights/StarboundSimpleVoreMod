--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

function init()

	victim = entity.id()
	self.victimtype = entity.entityType();
	owner = effect.sourceEntity();
	seatindex = nil;
	
	seatindexrpc = nil;
	
	satplayer = nil;
	
	--Need to update this sometimes, hm.
	--world.sendEntityMessage( owner, "vsoGetMySeatIndex", entity.id() );
	
	if victim == owner then
		effect.expire();
		--NOTE: apparently, status effects from vehicles don't have valid effect.sourceEntity() ??strange
	else
		
		
		--[[
		
		[23:11:09.830] [Info] mcontroller
		[23:11:09.830] [Info] mcontroller.xVelocity = function: 000000002F0DD450
		[23:11:09.830] [Info] mcontroller.yVelocity = function: 000000002F0DDC30
		[23:11:09.830] [Info] mcontroller.setYPosition = function: 000000002F0DE7D0
		[23:11:09.830] [Info] mcontroller.baseParameters = function: 000000002F0DE9B0
		[23:11:09.830] [Info] mcontroller.setAutoClearControls = function: 000000004C29CA20
		[23:11:09.830] [Info] mcontroller.addMomentum = function: 000000002F0DE950
		[23:11:09.830] [Info] mcontroller.collisionBody = function: 00000000125F22F0
		[23:11:09.830] [Info] mcontroller.isNullColliding = function: 000000002F0DE2F0
		[23:11:09.831] [Info] mcontroller.controlFly = function: 000000002F0DED10
		[23:11:09.831] [Info] mcontroller.flying = function: 000000002F0DEAA0
		[23:11:09.831] [Info] mcontroller.controlHoldJump = function: 000000002F0DECE0
		[23:11:09.831] [Info] mcontroller.controlFace = function: 000000002F0DECB0
		[23:11:09.831] [Info] mcontroller.controlJump = function: 000000004C29CB10
		[23:11:09.831] [Info] mcontroller.controlApproachXVelocity = function: 000000002F0DEC50
		[23:11:09.831] [Info] mcontroller.resetAnchorState = function: 000000002F0DD420
		[23:11:09.831] [Info] mcontroller.controlParameters = function: 000000002D7F2AD0
		[23:11:09.831] [Info] mcontroller.clearControls = function: 000000002F0DE890
		[23:11:09.831] [Info] mcontroller.controlApproachVelocityAlongAngle = function: 000000002F0DEC20
		[23:11:09.831] [Info] mcontroller.controlApproachVelocity = function: 000000002F0DEBF0
		[23:11:09.831] [Info] mcontroller.falling = function: 000000002F0DEA10
		[23:11:09.831] [Info] mcontroller.controlForce = function: 000000002F0DEBC0
		[23:11:09.831] [Info] mcontroller.controlAcceleration = function: 000000002F0DEB90
		[23:11:09.831] [Info] mcontroller.setXPosition = function: 000000002F0DE770
		[23:11:09.831] [Info] mcontroller.controlRotation = function: 000000002F0DEB60
		[23:11:09.831] [Info] mcontroller.boundBox = function: 000000004C29CD80
		[23:11:09.831] [Info] mcontroller.liquidMovement = function: 000000002F0DEB30
		[23:11:09.831] [Info] mcontroller.groundMovement = function: 000000002F0DEB00
		[23:11:09.831] [Info] mcontroller.facingDirection = function: 000000002F0DEA70
		[23:11:09.831] [Info] mcontroller.setRotation = function: 000000002F0DE980
		[23:11:09.831] [Info] mcontroller.jumping = function: 000000002F0DEAD0
		[23:11:09.831] [Info] mcontroller.translate = function: 000000002F0DE800
		[23:11:09.831] [Info] mcontroller.movingDirection = function: 000000002F0DEA40
		[23:11:09.831] [Info] mcontroller.running = function: 000000002F0DE9E0
		[23:11:09.831] [Info] mcontroller.yPosition = function: 000000000E922590
		[23:11:09.831] [Info] mcontroller.xPosition = function: 0000000023C0CB40
		[23:11:09.831] [Info] mcontroller.setYVelocity = function: 000000002F0DE920
		[23:11:09.831] [Info] mcontroller.stickingDirection = function: 000000002F0DD330
		[23:11:09.831] [Info] mcontroller.autoClearControls = function: 000000002F0DE8F0
		[23:11:09.831] [Info] mcontroller.liquidId = function: 000000002F0DE500
		[23:11:09.831] [Info] mcontroller.canJump = function: 000000002F0DE7A0
		[23:11:09.831] [Info] mcontroller.setVelocity = function: 000000002F0DE860
		[23:11:09.831] [Info] mcontroller.isColliding = function: 000000002F0DDC60
		[23:11:09.831] [Info] mcontroller.setAnchorState = function: 000000002F0DE590
		[23:11:09.831] [Info] mcontroller.controlModifiers = function: 000000002F0DEC80
		[23:11:09.831] [Info] mcontroller.liquidPercentage = function: 000000002F0DE4A0
		[23:11:09.831] [Info] mcontroller.setPosition = function: 000000002F0DE740
		[23:11:09.831] [Info] mcontroller.rotation = function: 000000002D76C540
		[23:11:09.831] [Info] mcontroller.isCollisionStuck = function: 000000004C29C900
		[23:11:09.831] [Info] mcontroller.setXVelocity = function: 000000002F0DE8C0
		[23:11:09.832] [Info] mcontroller.walking = function: 000000002F0DD150
		[23:11:09.832] [Info] mcontroller.crouching = function: 000000002F0DE470
		[23:11:09.832] [Info] mcontroller.velocity = function: 000000002F0DD6C0
		[23:11:09.832] [Info] mcontroller.anchorState = function: 000000004CF7D030
		[23:11:09.832] [Info] mcontroller.mass = function: 000000004C29C9C0
		[23:11:09.832] [Info] mcontroller.position = function: 000000002F0DD3F0
		[23:11:09.832] [Info] mcontroller.onGround = function: 000000002F0DE530
		[23:11:09.832] [Info] mcontroller.collisionPoly = function: 000000002E0FE320
		[23:11:09.832] [Info] mcontroller.controlCrouch = function: 000000002F0DE4D0
		[23:11:09.832] [Info] mcontroller.controlMove = function: 000000002F0DDB10
		[23:11:09.832] [Info] mcontroller.controlApproachYVelocity = function: 000000002F0DE830
		[23:11:09.832] [Info] mcontroller.controlDown = function: 0000000023C0D440
		
		
		sb.logInfo( "mcontroller" )
		for k,v in pairs( mcontroller ) do
			sb.logInfo( "mcontroller." .. k .." = " .. tostring( v ) )
		end
		--mcontroller.parameters
		--mcontroller.resetParameters
		--mcontroller.applyParameters
		--
		]]--
	
		--From "paralysis.lua"
		mcontroller.setVelocity({0, 0})
		
		--From fishingrod.lua and others
		mcontroller.controlModifiers({movementSuppressed = true, facingSuppressed = true, runningSuppressed = true, jumpingSuppressed = true})
		--airJumpModifier
		--speedModifier
			
		--Does invulnerable interfere with stat drain???
		--status.setPersistentEffects( "movementAbility", { { stat = "invulnerable", amount = 1.0}, {stat = "activeMovementAbilities", amount = 1} } )	--from tech scripts
		--this should disable the use of abilities...
		status.setPersistentEffects( "movementAbility", { {stat = "activeMovementAbilities", amount = 1} } )	--from tech scripts
		--Ooooooo this should help
		status.setPersistentEffects("weaponMovementAbility", {{stat = "activeMovementAbilities", amount = 1}})
		
		--status.setPersistentEffects("fishing", {{stat = "activeMovementAbilities", amount = 1}})
		--status.setPersistentEffects("grapplingHook"..activeItem.hand(), {{stat = "activeMovementAbilities", amount = 0.5}})
		--status.setPersistentEffects("railhook", {{stat = "activeMovementAbilities", amount = 1}})
		--status.setPersistentEffects("blinkexplosionability", {{stat = "activeMovementAbilities", amount = 1}})
		--"fishing"
		--"grapplingHook"..activeItem.hand()
		--"railhook"
		--"blinkexplosionability"
		--activeItem.hand().."Shield"
		--"broadswordParry"
		--"elementalAura"
		--"groundSlam"
		--"magnorbShield"
		--"protectorateProtection"
		--"owner"
		--"shipCrew"
		--"crew"
		
		--used a lot: not status.statPositive("activeMovementAbilities")
		
		if self.victimtype == "player" then
			
			--mcontroller.controlMove( 0, false );	--Hmmm...
			--mcontroller.controlJump( false );
			--mcontroller.controlCrouch( false );
			
			--From many
			--mcontroller.autoClearControls();	-- (SERIOUSLY inhibits player)
			--mcontroller.controlDown();	--Not sure what this is
			
			--mcontroller.setAnchorState()
			--local what = mcontroller.anchorState()
			--sb.logInfo( tostring( what ) );
			
			--mcontroller.setAutoClearControls( true );
			--mcontroller.controlParameters( {} )	--Not that useful!
			
			--world.sendEntityMessage( victim, "vsoForcePlayerSit", owner, seatindex )
		elseif world.isNpc( victim ) then
		
			if status.isResource("stunned") then
				status.setResource("stunned", 100 )--math.max(status.resource("stunned"), effect.duration()))
			end
			--world.callScriptedEntity( victim, "npc.setLounging", owner, seatindex )	--Works! But, doesn't change the npc DESIRE to be seated...
				
		else
			--sb.logInfo( "Can't continue sit: "..tostring(victim).." "..victimtype..": "..tostring( owner ) )
		end
   
		--From ballistapusher.lua   grit is... what?
		--{stat = "grit", amount = config.getParameter("gritAmount", 0)}
	
	end
end

function update(dt)

	if world.entityExists( entity.id() ) and world.entityExists( owner ) then
	
		mcontroller.setVelocity({0, 0})
		--The below creates a very hard motion lock (hm) but this is not generally needed
		mcontroller.controlModifiers({speedModifier = 0.0, airJumpModifier = false, movementSuppressed = true, facingSuppressed = true, runningSuppressed = true, jumpingSuppressed = true})
		
		--mcontroller.setPosition( ) Hm.
		
		if seatindexrpc == nil then
			seatindexrpc = world.sendEntityMessage( owner, "vsoGetVictimSeatIndex", entity.id(), owner )
		elseif seatindexrpc:finished() then
			seatindex = seatindexrpc:result();
			sb.logInfo( "got seat index ".. tostring( seatindex ) );
			if seatindex == nil then
			
			end
			seatindexrpc = nil;
		end
		
		if seatindex ~= nil then
			if self.victimtype == "player" then
			
				--THIS COULD BE GREAT!!!
				local sittingon, seatid = mcontroller.anchorState();
				if (sittingon ~= owner) or (seatid ~= seatindex) then
				
					mcontroller.resetAnchorState();
					world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", owner, seatindex )
				
					sb.logInfo( "forcing a sit "..tostring( entity.id() ).." on "..tostring( owner ).." in seat "..tostring( seatindex ) .." was " .. tostring( seatid ).." on "..tostring( sittingon ) );
					
					--mcontroller.setAnchorState( owner, seatindex )
					
					--0,1 did not work...
				
					--mcontroller.controlModifiers({ movementSuppressed = true, facingSuppressed = true, runningSuppressed = false, jumpingSuppressed = false })
					--world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", owner, seatindex )
				
				end
				
				--mcontroller.setAnchorState()
				--local what = mcontroller.anchorState()	--TELLS ME WHO I AM SITTING ON
				--if what ~= nil then 
				--	sb.logInfo( tostring( what ) );
				--end
			
				--From fishingrod.lua
				--mcontroller.controlJump( true );	--Hm not sure?
				--mcontroller.controlCrouch( true );
				
				--mcontroller.controlModifiers({movementSuppressed = true, facingSuppressed = true, runningSuppressed = false, jumpingSuppressed = true})
				
				--mcontroller.applyParameters( {} )
				--mcontroller.resetParameters( {} );--self.cfgVSO.movementSettings.default ) --Apply movement controller settings
					
				--if mcontroller.applyParameters ~= nil then
				--	mcontroller.applyParameters( {} )	--TEsting! Helps solve a strange glitch (potentially)
				--end
				
				--Only repeat AFTER the last sit went through? or failed?
				--if satplayer == nil then
				--	satplayer = world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", owner, seatindex )
				--elseif satplayer:finished() then
				--	--satplayer:result()
				--	satplayer = nil;
				--	satplayer = world.sendEntityMessage( entity.id(), "vsoForcePlayerSit", owner, seatindex )
				--end
				
			elseif world.isNpc( entity.id() ) then
				
				if status.isResource("stunned") then
					status.setResource("stunned", 100 )
				end
				local didit = world.callScriptedEntity( entity.id(), "npc.setLounging", owner, seatindex )
			else
				--
			end
		end
	else
		effect.expire();
	end
end

function uninit()

	--[[
	status.clearPersistentEffects( "movementAbility" )	--waht does this mean???
	status.clearPersistentEffects( "weaponMovementAbility" )	--waht does this mean???
	
	if status.isResource("stunned") then
		status.setResource("stunned", 0 )--math.max(status.resource("stunned"), effect.duration()))
	end
	mcontroller.controlModifiers({
		facingSuppressed = false,
		movementSuppressed = false
		mcontroller.controlModifiers({movementSuppressed = true, facingSuppressed = true, runningSuppressed = true, jumpingSuppressed = true})
	})
	]]--
end
