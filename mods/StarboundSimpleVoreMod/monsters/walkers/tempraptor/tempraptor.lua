require "/scripts/vore/vorex.lua"

-------------------------------------------------------------------------------
--CORE FUNCTIONS REQUIRED

function init()

	--CUSTOM STATE FUNCTION SIMPLE based AI
	
	--Note we overrode this: Because we want to handle "kockout" manually if possible.
	--"knockoutTime" : 0.3,
    --"knockoutAnimationStates" : {
    --  "damage" : "stunned"
    --},
	
	self.targetId = nil;	--Do your own targeting. But we suggest new targets for you.
	
	--Might make this a handy class later, since it's a bit icky
	--Build the state function list (yay)
	
	self.vx = Vorex:create( self, {
		default="idle" 
		, idle=stateIdle
		, attack=stateAttack
		, full=stateFull	
	} );
	
	--Build "animation set lists" so we can abstract the animations and layers insted of hard coding them
	self.vx:initAnimationLists( config.getParameter("animationSetLists") );
	self.vx:setAnimationList( "idle" );
	
	--some parameters are config file based, get these later
	--self.voreSearchBounds = config.getParameter("voreBounds")[ "default" ] );
	
	self.vx:setApplyTouchDamage( false );
	
end

function update(dt)
	self.vx:update( dt );
end

function shouldDie()

	-- if not status.resourcePositive("health") then
		-- --local deathexplosion = config.getParameter("deathexplosion")
		-- --if deathexplosion then
		-- --	world.spawnProjectile(deathexplosion.type, mcontroller.position(), entity.id(), {0, 1}, true, deathexplosion.config)
		-- --end
		-- return true
	-- else
		-- return false
	-- end

	return status.resource("health") <= 0;
	
end

function die()
	--capturable.die()
end

-------------------------------------------------------------------------------
--STATES

function stateIdle( dt, statedata )

	
	if self.vx:isStateRefreshed() then	--Note you don't usually care about this.
	
		local direction = math.random(3) - 2;	--0,1,2 -1 = -1,0,1	aw crap,  math.random(upper) generates integer numbers between 1 and upper.

		if direction ~= 0 then
			self.vx:setTimeout( math.random(7) );
		else
			self.vx:setTimeout( math.random(5) );
		end
		
		self.vx:setAnimationList( "idle" );
		self.moveDirection = direction;
		--self.vx:setStateData( { moveDirection=direction } );	--movement timeouts, Idle and Move are separate!
		
		sb.logInfo( "tempraptor stateIdle Refreshed "..tostring( self.moveDirection ) .." " .. tostring( self.vx:getTimeout() ) );
	end
	
	if self.vx:getSuggestedTarget() ~= nil then
	
		self.vx:setSuggestedTarget( nil );	--We shall investigate targeting AI when we get there, for now clear it.
		
		self.vx:setState( "attack" );	--go to attack state		
	end
	
	if direction ~= 0 then
		self.vx:movementApply( self.moveDirection, false );
	else
		
	end

end

function stateAttack( dt, statedata )
 
	if self.vx:isStateRefreshed() then	--Note you don't usually care about this.
		
		self.vx:setAnimationList( "damage" );	--If we manually time out, we want to sync to an animation
		
		self.vx:setApplyTouchDamage( true );
	
		self.vx:setNextState( "idle" );
		self.vx:setTimeout( 1 );
		
		sb.logInfo( "tempraptor stateAttack Refreshed " .. tostring( self.vx:getTimeout() ) );
	end
	
end

function stateFull( dt, statedata )

	if self.vx:isStateRefreshed() then	--Note you don't usually care about this.
		
		sb.logInfo( "tempraptor stateAttack Full" );
		
	end
	
	self.vx:setAnimationList( "full" );
end

