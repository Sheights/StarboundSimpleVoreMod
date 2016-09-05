
oldInit = init
oldInteract = interact
oldUpdate = update

---------------------------------------------------------------------------------------
--#####################################################################################
--CONFIG SECTION (replace later using real config file instead of script config)

-- Audio will activate, Guess what, the audio portion of the mod. This will turn off audio for all preds.
-- For individual preds, you can overide this value to suit your needs.
-- This line can either be "true" or "false"
enableAudio = true

digestsound		= "digestprojectile"
swallowsound 	= "swallowprojectile"

voreAttackDelaySeconds = 0.25;

--#####################################################################################
---------------------------------------------------------------------------------------

--end user monster API callbacks
function initHook() end
function feedHook() end
function digestHook() end
function gainHook() end
function loseHook() end
function updateHook(dt) end
function interactHook(args) end

--monster API Calls you can use
function isFed() end
function attemptFeed() end
function setSearchBounds( bndstable ) end

--Compatibility with vore mod, allows us to spawn vore sound projectiles! it's a nice solution to a annoying problem
function spawnSoundProjectile( projectilename )
	if enableAudio then
		world.spawnProjectile( projectilename , mcontroller.position() , entity.id(), {0, 0}, false );
	end
end

function init()

	oldInit()
		
	self.voreDuration = 30;	--In seconds
	self.voreAttackDelay = voreAttackDelaySeconds	--seconds
	--self.stopWatch	= 0	--Current "inside predator" time; should be different for each victim (use victim list)
	self.doubleClickTimer	= 1;
	self.clickEnergy = 0;	--Basically a "average clicks per second" like value
	self.monsterSearchBounds = {-1,-0.5, 1,0.5 };	-- xmin, ymin, xmax, ymax

	self.fed = false;
	self.victim = nil;
	self.victims = {};
	self.voreAttackTimeout = 0.0;
	self.preyMovement = {0,0,0,0};

	message.setHandler("voreAttackStatusMessage", function(_, _, voretype, preyid )	--Told we either hit or missed our prey
		voreAttackStatusChange( voretype, preyid );
	end)
			
	message.setHandler("voreMovementOfPrey", function(_, _, vx, vy )	--Sent from the prey, assuming we can get input from them
		self.preyMovement[1] = vx;
		self.preyMovement[2] = vy;
    end)
	
	initHook()
	
end

function update(dt)

	tempupdate = update		--HACK to prevent some kind of really strange stuff from happening
	tempinteract = interact	--Something about using huge gaps in the update; will investigate later.
	oldUpdate(dt)
	
	if self.fed then	
	
		if digest() then
			
			if( self.clickEnergy > 1 ) then	--hmmm
			
				world.sendEntityMessage( self.victim, "voreCaptureDisable", entity.id() );	--requested escape
				
				--self.stopWatch = self.voreDuration+1;
			else
					
				if math.random(350) == 1 then
					spawnSoundProjectile( digestsound );
				end
				
				if self.doubleClickTimer < 1 then
					self.doubleClickTimer = self.doubleClickTimer + dt
				end
				
				--self.stopWatch = self.stopWatch + dt
			end
		end
	else
		self.voreAttackTimeout = self.voreAttackTimeout - dt;
	end
	
	self.clickEnergy = self.clickEnergy - 0.9 * dt;	--Lose 0.9 click energy per second at a linear rate

	updateHook(dt)
	update = tempupdate
	interact = tempinteract
	
end

function interact( args )
	
	oldInteract(args)
	
	if args.sourceId == self.victim then	--ONLY a victim can interact with me for vore purposes
		
		if self.doubleClickTimer < 1 then	--Double Click interaction
		
			self.clickEnergy = self.clickEnergy  + ( 1.0 / (1 + self.doubleClickTimer) );	--The faster you click, the more energy that is accumulated.
		else
		
			self.clickEnergy = 0;	--Single click interaction resets click energy
		end
		
		self.doubleClickTimer = 0;	
	else
		--Others can't do anything except "admire" that their friend/enemy is eaten, so they should say something
	end
	 
	interactHook(args)

	return nil
end

function isFed()
	return self.fed;
end

function genTableString( K, V )

	local S = K.."\r\n";
	for key,value in pairs( V ) do
		S = S.."\t"..tostring( key ).." = "..tostring( value ).."\r\n";
	end
	local mt = getmetatable(V);
	if mt ~= nil then
		S = S.."METATABLE:\r\n";
		for key,value in pairs( mt ) do
			S = S.."\t"..tostring( key ).." = "..tostring( value ).."\r\n";
		end
	end
	return S;
end

--Shold only be called once in an update
function attemptFeed()
	if not self.fed then
		if self.voreAttackTimeout > 0 then
			--nope
		else
			feed();
			return true;
		end
	end
	return false;
end

function setSearchBounds( bndstable )
	
	self.monsterSearchBounds[1] = bndstable[1][1];
	self.monsterSearchBounds[2] = bndstable[1][2];
	self.monsterSearchBounds[3] = bndstable[2][1];
	self.monsterSearchBounds[4] = bndstable[2][2];
end

function feed()

	self.voreAttackTimeout = self.voreAttackDelay;	--wait 1/4 second for each vore attack check

	local Bbnds = {{0,0},{0,0}};
	local mp = mcontroller.position();
	Bbnds[1][1] = mp[1] + self.monsterSearchBounds[1];
	Bbnds[1][2] = mp[2] + self.monsterSearchBounds[2];
	Bbnds[2][1] = mp[1] + self.monsterSearchBounds[3];
	Bbnds[2][2] = mp[2] + self.monsterSearchBounds[4];
	
	world.debugPoly( { {Bbnds[1][1],Bbnds[1][2]}, {Bbnds[2][1],Bbnds[1][2]},{Bbnds[2][1],Bbnds[2][2]},{Bbnds[1][1],Bbnds[2][2]} }, { 255, 0, 255, 255 } );
	
	--This checks who I can grab. This is the "attack" box relative to the enemy, but ignores facing? Fix later.
	local people = world.entityQuery( Bbnds[1], Bbnds[2], {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	if #people > 0 then
	
		self.victim = people[1];
		
		local isPlayer = not world.isNpc( self.victim );	--Only true since we are searching for NPC's and Players
		
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( self.victim ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			return
		end
		
		if world.entityCanDamage( entity.id(), self.victim ) then
			
			--sb.logInfo( "voreAttempt: "..tostring(Bbnds[1][1]).." "..tostring(Bbnds[1][2]).." "..tostring(Bbnds[2][1]).." "..tostring(Bbnds[2][2]).." vic:"..tostring(self.victim).." eid:"..tostring(entity.id()) );
	
			world.sendEntityMessage( self.victim, "applyStatusEffect", "monstervorerequest", self.voreDuration, entity.id() )
		end
	end
end

function terminateVore()		

	if self.fed then
	
		loseHook()	--Called when we are suddenly losing a victim
	end
	
	self.fed = false	
	self.victim = nil;
	self.voreAttackTimeout = 1.0 + self.voreAttackDelay;	--at least 1 extra second tacked on
	--self.stopWatch	= self.voreDuration + 1;
	self.doubleClickTimer = 1;
	self.clickEnergy = 0;

end

function digest()

	--Instead of a stopWatch, we need to check if the player is "out" yet or not
	--So...

	--if self.stopWatch < self.voreDuration then
	
	digestHook()	--Only called if we are fed. Should be called per victim
	--else
	--	terminateVore()
	--	return false;
	--end
	return true;
end

function voreAttackStatusChange( statval, targetid )
	
	--sb.logInfo( "voreAttackStatusChange: vorestat:"..tostring(statval).." fed:"..tostring(self.fed).." targid:"..tostring(targetid).." victim: "..tostring(self.victim).." eid:"..tostring(entity.id()) );
	
	if self.victim == targetid then --MUST be the victim I was attacking telling me to stop voring stuff
		
		if statval < 0 then
		
			terminateVore();
		else
		
			if self.fed then
				sb.logInfo( "ERROR voreAttackStatusChange: vorestat:"..tostring(statval).." fed:"..tostring(self.fed).." targid:"..tostring(targetid).." victim: "..tostring(self.victim).." eid:"..tostring(entity.id()) );
			end
					
			--object.setConfigParameter( "renderLayer", "foregroundEntity" );
			--Hm	"Player" "Monster" "Player+1" and so on
			--object.setConfigParameter( "baseParameters", { renderLayer="Player+1" } );
			--baseParameters -> renderLayer = "foregroundEntity" or "Player+1" ?
			--mcontroller.baseParameters
			
			feedHook();
			
			self.fed = true;

			self.doubleClickTimer = 1;
			
			--self.stopWatch = 0;

			spawnSoundProjectile( swallowsound );
			
			gainHook()
		end
	end		
end
