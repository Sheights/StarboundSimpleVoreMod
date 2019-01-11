require "/scripts/sensors.lua"
require "/scripts/status.lua"
require "/scripts/util.lua"

-- Vore utilities as a class, for state machine AI enemies to clean up their logic
Vorex = {}
Vorex.useVore = true;	--globals for ALL vorex classess

-------------------------------------------------------------------------------
--API LIST




-------------------------------------------------------------------------------
--API IMPLEMENTATION

--Create a new Vorex class (to store prey, vore state, and such)
function Vorex:create( owner, funclist )

	local instance = {};

	instance.owner = owner;
	instance.whater = value;
	instance.emptytable = {};

	instance.fnList = funclist;

	instance.fnPrevious = "";
	instance.fnCurrent = instance.fnList["default"];
	instance.fnNext = instance.fnList["default"];
	instance.fnTimer = 0.0;
	instance.fnTimerTimeout = util.randomInRange( 15 );

	instance.bitIgnoreDamage = false;
	instance.bitIgnoreTimeout = false;

	instance.targetID = nil;	--No target currently
	instance.targetAutoSuggestion = nil;	--No currently suggested target
	instance.targetAutoMethod = 1;	--0 == disable, 1 == "first", 2 = "mostDamage", 3 = "leastDamage", 4 = "mostFrequent"

	instance.damageTakenSinceTimer = 0;
	instance.hasNewState = false;
	instance.hasRefreshedState = false;

	instance.targetAutoMethods = { VorexAutoTargetMethodFirst, VorexAutoTargetMethodFirst, VorexAutoTargetMethodFirst, VorexAutoTargetMethodFirst };

	instance.animationList = "default";
	instance.animationListPrev = "";
	instance.animationLists = { default={} };

	setmetatable(instance, { __index = self });

	---Extra stuff

	return instance;
end

--This toggles the applicaiton of damage on touch of this monster
function Vorex:setApplyTouchDamage( v )
	if monster ~= nil then
		monster.setDamageOnTouch( v );
	end
	self.touchDamageEnabled = v;	--HEY LOOK, a hack
end

function Vorex:movementApply( direction, run )
	mcontroller.controlMove( direction, run );
end

--[[
--This acquires a new target if we don't already have one. Pulse this.
function trackTarget()
	if not self.targetId or not world.entityExists(self.targetId) then
		self.targetId = util.closestValidTarget(25.0)
		if self.targetId == 0 then 
			self.targetId = nil 
		end
	end

	if self.targetId then
		self.targetPosition = world.entityPosition(self.targetId)
	else
		self.targetPosition = nil
	end
end

--Abstract this later
function applyAnimationSetList( key );
	local T = self.asList[ key ]
	for key, value in pairs( T ) do
		animator.setAnimationState( key, value )
	end
end

function applyMovement(direction, run)
	mcontroller.controlMove( direction, run );
end
]]--

function Vorex:setIgnoreDamage( v )
	self.bitIgnoreDamage = v;
end

function Vorex:setIgnoreTimeout( v )
	self.bitIgnoreTimeout = v;
end

function Vorex:setTimeout( v )
	self.fnTimerTimeout = v;
end

function Vorex:getTimeout( v )
	return self.fnTimerTimeout;
end

function Vorex:isNewState()
	return self.hasNewState
end

function Vorex:setState( newstate )
	self.fnCurrent = newstate;
end

function Vorex:setNextState( newstate )
	self.fnNext = newstate;
end

function Vorex:isStateRefreshed()
	return self.hasNewState or self.hasRefreshedState;
end

function Vorex:getSuggestedTarget()
	return self.targetAutoSuggestion;
end

function Vorex:setSuggestedTarget( v )
	self.targetAutoSuggestion = v;
end

function Vorex:setAnimationList( aname )

	--[23:50:08.257] [Info] tempraptor Vorex:setAnimationList idle nil nil
	--sb.logInfo( "tempraptor Vorex:setAnimationList "..tostring( self ).." "..tostring( animationList ).." "..tostring( aname ) );

	self.animationList = aname;
end

function Vorex:initAnimationLists( al )
	self.animationLists = al;
end

function Vorex:update( dt )

	--We can use DIRECT damage listening. So yay. no need for the wrapper. This enables a lot more fun anyways
	if self.targetAutoMethod > 0 then
		local notifications = {};
		notifications, self.damageTakenSinceTimer = status.damageTakenSince( self.damageTakenSinceTimer );	--status.inflictedHitsSince, status.inflictedDamageSince
		if #notifications > 0 then
			self.targetAutoMethods[ self.targetAutoMethod ]( self, notifications );
		end
	end
	
	self.fnTimer = self.fnTimer + dt;
	if not self.bitIgnoreTimeout then
		if self.fnTimer > self.fnTimerTimeout then
			self.fnTimer = 0.0;		
			self.fnTimerTimeout = util.randomInRange( 15 );		
			self.fnCurrent = self.fnNext;
			self.hasRefreshedState = true;
		end
	end
	
	--Are we actually in a new state? (has it changed?)
	self.hasNewState = self.fnPrevious ~= self.fnCurrent;
	self.hasRefreshedState = self.hasRefreshedState or self.hasNewState;
	self.fnPrevious = self.fnCurrent;
	
	--Call the current state function
	local retstate = self.fnList[ self.fnCurrent ]( dt );
	
	self.hasRefreshedState = false;
	
	--Did we request a new state?
	if retstate == true then
		self.fnTimer = 0.0;		
		self.fnCurrent = self.fnNext;
		self.hasRefreshedState = true;
	end
	
	--Update animation list if changed
	if self.animationList ~= self.animationListPrev then
		for key, value in pairs( self.animationLists[ self.animationList ] ) do
			animator.setAnimationState( key, value )
		end
		self.animationListPrev = self.animationList;
	end
	
end

-------------------------------------------------------------------------------
--NON API CALLS
	
function VorexAutoTargetMethodFirst( instance, ns )
	for ihit, ndata in ipairs( ns ) do
		if ndata.healthLost > 0 then
			instance.targetAutoSuggestion = ndata.sourceEntityId;
			break;
		end
	end
end

	
-- --Interesting, but we can SET a function as a coroutine how neat. Does this mean any function can be called with a list of arguments?
-- function Vorex:setCallback(state, ...)
  -- if state == nil then
    -- self.state = nil
    -- return
  -- end
  -- self.state = coroutine.wrap(state)
  -- self.state(...)
-- end

-- --Update the Vorex system. Required.
-- function Vorex:update(dt)
  -- return self.state and self.state()
-- end




--[[

--Simple Function state machine

function sfnInit( flist )
	--error check list of course

	self.sfnList = flist;

	self.sfnPrevious = "";
	self.sfnCurrent = self.sfnList["default"];
	self.sfnNext = self.sfnList["default"];
	self.sfnTimer = 0.0;
	self.sfnTimerTimeout = util.randomInRange( 15 );
	self.sfnIgnoreDamage = false;
	self.sfnIgnoreTimeout = false;
	self.sfnTargetID = nil;	--No target currently
	self.sfnAutoTargetSuggestion = nil;	--No currently suggested target
	self.sfnAutoTargetMethod = 1;	--0 == disable, 1 == "first", 2 = "mostDamage", 3 = "leastDamage", 4 = "mostFrequent"
	self.sfnDamageTakenSince = 0;
	self.sfnNewState = false;
	self.sfnRefreshState = false;
	self.sfnAutoTargetMethods = { sfnAutoTargetMethodFirst, sfnAutoTargetMethodFirst, sfnAutoTargetMethodFirst, sfnAutoTargetMethodFirst };
	self.sfnAnimationList = "default";
	self.sfnAnimationListPrev = "";
	self.sfnAnimationLists = { default={} };
end

function sfnIgnoreDamage( v )
	self.sfnIgnoreDamage = v;
end

function sfnSetIgnoreTimeout( v )
	self.sfnIgnoreTimeout = v;
end

function sfnSetTimeout( v )
	self.sfnTimerTimeout = v;
end

function sfnIsNewState()
	return self.sfnNewState
end

function sfnSetState( newstate )
	self.sfnCurrent = newstate;
end

function sfnSetNextState( newstate )
	self.sfnNext = newstate;
end

function sfnIsStateRefreshed()
	return self.sfnNewState or self.sfnRefreshState;
end

function sfnAutoTargetMethodFirst( ns )
	for ihit, ndata in ipairs( ns ) do
		if ndata.healthLost > 0 then
			--sb.logInfo( "tempraptor sfnAutoTargetSuggestion "..tostring(ndata.sourceEntityId) );
			self.sfnAutoTargetSuggestion = ndata.sourceEntityId;
			break;
		end
	end
end

function sfnGetSuggestedTarget()
	return self.sfnAutoTargetSuggestion;
end

function sfnSetSuggestedTarget( v )
	self.sfnAutoTargetSuggestion = v;
end

function sfnSetAnimationList( aname )
	self.sfnAnimationList = aname;
end

function sfnInitAnimationList( al )
	self.sfnAnimationLists = al;
end
	
function sfnUpdate( dt )

	--We can use DIRECT damage listening. So yay. no need for the wrapper. This enables a lot more fun anyways
	if self.sfnAutoTargetMethod > 0 then
		local notifications = {};
		notifications, self.sfnDamageTakenSince = status.damageTakenSince( self.sfnDamageTakenSince );	--status.inflictedHitsSince, status.inflictedDamageSince
		self.sfnAutoTargetMethods[ self.sfnAutoTargetMethod ]( notifications );
	end
	
	self.sfnTimer = self.sfnTimer + dt;
	if not self.sfnIgnoreTimeout then
		if self.sfnTimer > self.sfnTimerTimeout then
			self.sfnTimer = 0.0;		
			self.sfnTimerTimeout = util.randomInRange( 15 );		
			self.sfnCurrent = self.sfnNext;
			self.sfnRefreshState = true;
		end
	end
	
	--Are we actually in a new state? (has it changed?)
	self.sfnNewState = self.sfnPrevious ~= self.sfnCurrent;
	self.sfnRefreshState = self.sfnRefreshState or self.sfnNewState;
	self.sfnPrevious = self.sfnCurrent;
	
	--Call the current state function
	local retstate = self.sfnList[ self.sfnCurrent ]( dt );
	
	self.sfnRefreshState = false;
	
	--Did we request a new state?
	if retstate == true then
		self.sfnTimer = 0.0;		
		self.sfnCurrent = self.sfnNext;
		self.sfnRefreshState = true;
	end
	
	
	if self.sfnAnimationList ~= self.sfnAnimationListPrev then
		for key, value in pairs( self.sfnAnimationLists[ self.sfnAnimationList ] ) do
			animator.setAnimationState( key, value )
		end
		self.sfnAnimationListPrev = self.sfnAnimationList;
	end
	
end
]]--
