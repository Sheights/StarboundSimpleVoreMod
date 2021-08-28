--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ Zovoroth

require("/scripts/vore/vsosimple.lua")

--[[

ConstrictorSnake plan:

	While idle:
		-Occasionally bobs its head or flicks its tongue.
		-If someone stands next to it for a time or interacts with it while in the right position, it will bite and constrict them.

	While constricting:
		-The prey will begin to suffocate unless it doesn't need air.
			-If the prey's health drops low enough (~25%), they will stop suffocating and the snake will begin to eat them.
		-The prey can struggle to attempt to break free.
			-If they struggle enough, they will be released.
			-If they don't struggle at all and "play dead", the snake will begin to eat them.

	While full:
		-The prey can struggle to attempt to break free.
			-If they struggle enough, they will be released, but the chance is low.
		-If digestion pills are active, the prey will gradually be digested and lose health.
			-If the prey loses all of their health, a digestion animation will play.
			-If the pill was a normal digestion pill, the prey will be killed.
			-If the pill was a soft digestion pill, the prey will disappear until they press a button.

	Pills:
		Digest - Swallowed prey will take damage over time. Once they lose all health, they will die after an animation.
		Soft Digest - Swallowed prey will take damage over time. Once they lose all health, they will disappear until they move.
		Heal - Prey will not suffocate when constricted. Swallowed prey will gain health over time.
		Anti-Escape - It will be harder for prey to escape constriction and much harder for prey to escape being swallowed.
		Easy-Escape - It will be easier for prey to escape constriction and being swallowed.
	
]]--

function loadStoredData()
	vsoStorageSaveAndLoad( function()	--Get defaults from the item spawner itself
		if storage.colorReplaceMap ~= nil then
			vsoSetDirectives( vsoMakeColorReplaceDirectiveString( storage.colorReplaceMap ) );
		end
	end )
end

function showEmote( emotename )	--helper function to express a emotion particle	"emotesleepy","emoteconfused","emotesad","emotehappy","love"
	if vsoTimeDelta( "emoteblock" ) > 1 then
		animator.setParticleEmitterBurstCount( emotename, 1 );
		animator.burstParticleEmitter( emotename )
	end
end

-------------------------------------------------------------------------------

function onForcedReset( )	--helper function. If a victim warps, vanishes, dies, force escapes, this is called to reset me. (something went wrong) 

	vsoAnimSpeed( 1.0 );
	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( false, "drivingSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	vsoAnim( "bodyState", "idle" )
	
	vsoMakeInteractive( true )
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.

	vsoEffectWarpIn();	--Play warp in effect
	
	onForcedReset();	--Do a forced reset once.
	
	vsoStorageLoad( loadStoredData );	--Load our data (asynchronous, so it takes a few frames)
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_idle", function()
		vsoUseLounge( false, "drivingSeat" )
		vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )

		vsoCounterReset( "hunger", 0.0, 10.0 );

		vsoClearTarget("food");
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
	
		local anim = vsoAnimCurr( "bodyState" );

		--Clearly you must be volunteering!
		vsoSetTarget("food", targetid);
		--Maximize interest!
		vsoCounterAdd("hunger", 10.0);
		--Get happy about it
		showEmote("emotehappy");
	end )
	
	vsoOnEnd( "state_idle", function()
	
	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_grab", function()
		vsoAnim( "bodyState", "grab" )

		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnim( "drivingSeat", "playergrab", "bodyState" )
		vsoUseLounge( true, "drivingSeat" )
		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )

		--TODO: Grab status
		--vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatemaw" } );

		vsoMakeInteractive( false )
	end )
	
	vsoOnEnd( "state_grab", function()
	
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_hold", function()
	
		vsoAnim( "bodyState", "hold"  )
		
		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnim( "drivingSeat", "playerhold" )
		vsoUseLounge( true, "drivingSeat" )
		
		--TODO: Held status
		--vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatemaw" } );

		vsoCounterReset( "squirming" );
		self.squirmMinimum = 10;
		self.squirmMaximum = 20;
		self.cannotSquirm = false;
		self.preyBreath = 1.0;
		self.preyHealth = 1.0;
		self.suffocateSoundTimer = 0;

		--Handle escape-related pills
		if vsoPill("antiescape") then
			local multiplier = vsoPillValue("antiescape") or 1.0;
			self.squirmMinimum = math.floor(self.squirmMinimum + (multiplier * 10.0));
			self.squirmMaximum = math.floor(self.squirmMaximum + (multiplier * 20.0));
		end
		if vsoPill("easyescape") then
			local multiplier = vsoPillValue("easyescape") or 1.0;
			self.squirmMinimum = math.max(math.floor(self.squirmMinimum - (multiplier * 5.0)), 0);
			self.squirmMaximum = math.max(math.floor(self.squirmMaximum - (multiplier * 10.0)), 0);
		end

		--vsoTimerSet( "swallowTimer", 15.0, 40.0 ) --Delay before swallowing
		vsoTimeDelta("swallowDelay");
	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_hold_release", function()
		vsoUneat( "drivingSeat" )
		
		vsoClearTarget( "food" )
		vsoAnim( "bodyState", "release" )
		vsoUseLounge( false, "drivingSeat" )
	end )
	
	vsoOnEnd( "state_hold_release", function()

	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_swallow", function()
	
		vsoAnim( "bodyState", "swallow"  )
		
		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnim( "drivingSeat", "playereat", "bodyState" )
		vsoUseLounge( true, "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatemaw" } );
	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_full", function()
	
		vsoAnim( "bodyState", "full"  )
		
		vsoVictimAnimVisible( "drivingSeat", false )
		vsoVictimAnim( "drivingSeat", "playereaten" )
		vsoUseLounge( true, "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatebelly" } );

		vsoCounterReset( "squirming" );
		self.digestTicker = 0.0;
		self.squirmMinimum = 10;
		self.squirmMaximum = 100;

		--Handle escape-related pills
		if vsoPill("antiescape") then
			local multiplier = vsoPillValue("antiescape") or 1.0;
			self.squirmMinimum = math.floor(self.squirmMinimum + (multiplier * 10.0));
			self.squirmMaximum = math.floor(self.squirmMaximum + (multiplier * 100.0));
		end
		if vsoPill("easyescape") then
			local multiplier = vsoPillValue("easyescape") or 1.0;
			self.squirmMinimum = math.max(math.floor(self.squirmMinimum - (multiplier * 5.0)), 0);
			self.squirmMaximum = math.max(math.floor(self.squirmMaximum - (multiplier * 80.0)), 0);
		end
		
		vsoTimerSet( "gurgle", 1.0, 8.0 )	--For playing sounds
		
	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_full_release", function()
		vsoAnim( "bodyState", "digest" )
	end )
	
	vsoOnEnd( "state_full_release", function()

		vsoUneat( "drivingSeat" )
		
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked"
		
		vsoSetTarget( "food", nil )
		vsoAnim( "bodyState", "idle" )
		vsoUseLounge( false, "drivingSeat" )
	end )

	---------------------------------------------------------------------------

	vsoOnBegin( "state_digest", function()
		vsoAnim( "bodyState", "digest" )
	end )
	
	vsoOnEnd( "state_digest", function()

		vsoUneat( "drivingSeat" )
		
		vsoSetTarget( "food", nil )
		vsoAnim( "bodyState", "idle" )
		vsoUseLounge( false, "drivingSeat" )
	end )

end

-------------------------------------------------------------------------------

function onEnd()
	
	vsoEffectWarpOut();
	
end

-------------------------------------------------------------------------------

function state_idle()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		--Tongue flick increases hunger!
		if anim == "idle_tongue" then
			vsoCounterAdd("hunger", 1.0);
		end

		local nextAnim = "idle";
		if vsoChance(40) then
			nextAnim = vsoPick({"idle_headbob","idle_tongue"});
		end
		vsoAnim( "bodyState",  nextAnim )
	end

	--Find a target roughly in range
	vsoUpdateTarget("food", 2.5, -4.0, 5.0, 1.0, { order = "random" });
	vsoDebugRelativeRect(2.5, -4.0, 5.0, 1.0, "red");

	if vsoValidTarget("food") then
		--Prey is nearby, so get hungrier!
		vsoCounterAdd( "hunger", self.vsodt );
		if vsoCounterChance("hunger", 3.0, 10.0) then
			vsoNext("state_grab");
		end
	else
		--No prey? Lose interest!
		vsoCounterSub( "hunger", self.vsodt/2.0 );
	end
	
end

-------------------------------------------------------------------------------

function state_grab()

	local anim = vsoAnimCurr( "bodyState" );

	if vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_hold" );
	end

	--In case prey somehow leaves
	if not vsoTargetIsEaten( "food" ) then
		vsoUneat( "drivingSeat" );
		vsoNext( "state_idle" );
	end

end

-------------------------------------------------------------------------------

function state_hold()

	local anim = vsoAnimCurr( "bodyState" );

	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState", "hold"  )
	end

	--In case prey somehow leaves
	if not vsoTargetIsEaten( "food" ) then
		vsoUneat( "drivingSeat" );
		vsoNext( "state_hold_release" );
	end

	local movetype,movedir = vso4DirectionInput( "drivingSeat" );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
	if movetype == -1 then	--Is it a NPC we just ate?
		if vsoChance( 3 ) then	--They dont like it? Hm.
			movetype = 1;
			movedir = vsoPick( {"F", "B", "U", "D"} );
		end
	end

	--Can only struggle during the "default" full animation
	if anim == "hold" then
		--Any button press at all
		--But once health drops too low, squirming is no longer possible
		if movetype > 0 and not self.cannotSquirm then
			local nextanim = anim;
			--All directions are the same
			if movetype == 2 then
				nextanim = "hold_squirm";
			else
				nextanim = "hold_squirmfast";
			end

			vsoAnim("bodyState", nextanim);
			--TODO: Some sort of victim animation?
			--TODO: Different struggle sound?
			vsoSound( "struggle" );

			if vsoCounterChance( "squirming", self.squirmMinimum, self.squirmMaximum ) then
				vsoNext( "state_hold_release" );
			else
				vsoCounter( "squirming" );
				vsoTimeDelta("swallowDelay"); --Prey is still squirming, so keep constricting!
			end	
		else
			vsoCounterSub( "squirming", self.vsodt/2.0 );	--just in case!
		end
	end

	local randomDelay = vsoRand(15.0,40.0);
	if self.cannotSquirm then
		--Prey finally stopped moving!
		randomDelay = vsoRand(3.0,10.0);
	end
	if vsoTimeDelta("swallowDelay", true) >= randomDelay then
		vsoNext( "state_swallow" );
	end

	--TODO: Maybe tie to a pill?
	--Prey begins to suffocate as it is constricted!
	--Regen rate is 10.0 and normal depletion rate is -4
	vsoResourceAddPercent( vsoGetTargetId("food"), "breath", -14 * self.vsodt);

	vsoResourceGet(vsoGetTargetId("food"), "breath", function(resources)
		if resources['breath'] ~= nil then  --some things DONT have breath...
			self.preyBreath = resources.breath[3];
		end
		self.preyHealth = resources.health[3];
	end);

	--This code is basically from player_primary.lua
	--These values won't be exactly up-to-date, but it should be close enough
	if self.preyBreath <= 0 then 
		self.suffocateSoundTimer = self.suffocateSoundTimer - self.vsodt
		if self.suffocateSoundTimer <= 0 then
	  		self.suffocateSoundTimer = 0.5 + (0.5 * self.preyHealth)
	  		vsoSound("suffocate")
		end
		vsoResourceAddPercentThreshold(vsoGetTargetId("food"), "health", -5 * self.vsodt, 20)
	else
		self.suffocateSoundTimer = 0
	end

	--Prey loses the ability to squirm when health gets low
	if self.preyHealth <= 0.25 and not self.cannotSquirm then
		self.cannotSquirm = true;
		vsoTimeDelta("swallowDelay");
	end
end

-------------------------------------------------------------------------------

function state_hold_release()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_idle" )
	end
end

-------------------------------------------------------------------------------

function state_swallow()

	local anim = vsoAnimCurr( "bodyState" );

	if vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_full" );
	end

	--In case prey somehow leaves
	if not vsoTargetIsEaten( "food" ) then
		vsoUneat( "drivingSeat" );
		vsoNext( "state_idle" );
	end
end

-------------------------------------------------------------------------------

function state_full()

	if vsoTimerEvery( "gurgle", 1.0, 8.0 ) then	--play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
		vsoSound( "digest" )
	end

	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState", "full"  )
	end

	--In case prey somehow leaves
	if not vsoTargetIsEaten( "food" ) then
		vsoUneat( "drivingSeat" );
		vsoNext( "state_hold_release" );
	end

	local movetype,movedir = vso4DirectionInput( "drivingSeat" );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
	if movetype == -1 then	--Is it a NPC we just ate?
		if vsoChance( 3 ) then	--They dont like it? Hm.
			movetype = 1;
			movedir = vsoPick( {"F", "B", "U", "D"} );
		end
	end

	--Can only struggle during the "default" full animation
	if anim == "full" then
		--Any button press at all
		if movetype > 0 then
			local nextanim = anim;
			--Which direction did we press?
			if movedir == "F" then
				if movetype == 2 then nextanim = "squirmF" else nextanim = "squirmfastF"; end
			elseif movedir == "B" then
				if movetype == 2 then nextanim = "squirmB" else nextanim = "squirmfastB"; end
			elseif movedir == "U" then
				if movetype == 2 then nextanim = "squirmU" else nextanim = "squirmfastU"; end
			elseif movedir == "D" then
				if movetype == 2 then nextanim = "squirmD" else nextanim = "squirmfastD"; end
			else
				--Random direction
				nextanim = vsoPick( {"squirmfastF","squirmfastB","squirmfastU","squirmfastD"} );
			end

			vsoAnim("bodyState", nextanim);
			vsoSound( "struggle" );

			if vsoCounterChance( "squirming", self.squirmMinimum, self.squirmMaximum ) then
				vsoNext( "state_full_release" )
			else
				vsoCounter( "squirming" )
			end		
		else
			vsoCounterSub( "squirming", self.vsodt/2.0 );	--just in case!
		end
	end

	--Optional Digestion and Healing
	if vsoPill("digest") or vsoPill("softdigest") or vsoPill("heal") then
		self.digestTicker = self.digestTicker + vsoDelta();
		--Determine whether to heal or hurt and by how much
		local digestRate = 0.0;
		if vsoPill("digest") then
			digestRate = digestRate + (vsoPillValue("digest") or 1.0);
		end
		if vsoPill("softdigest") then
			digestRate = digestRate + (vsoPillValue("softdigest") or 1.0);
		end
		if vsoPill("heal") then
			digestRate = digestRate - (vsoPillValue("heal") or 1.0);
		end
		--Tie damage to game time to keep it consistent and smooth
		local digestDamage = -5.0 * self.digestTicker * digestRate;
		if math.abs(digestDamage) >= 1.0 then
			self.digestTicker = 0.0;
			if not vsoPill("softdigest") then
				--Ends in the death of the victim!
				vsoResourceAddPercent( vsoGetTargetId("food"), "health", digestDamage, function(stillalive)
					if not stillalive then
						vsoApplyStatus( "food", "vsokillnpcsit", 1.0 )
						vsoNext( "state_digest" )
					end
				end );
			else
				--Victim gets to stick around
				vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", digestDamage, 0, function(stillhealthy)
					if not stillhealthy then
						--Victim is "absorbed" - stays with pakkun but can leave any time
						--vsoUneat("absorbedSeat");
						--vsoEat(vsoGetTargetId("food"), "absorbedSeat");
						--vsoVictimAnim( "absorbedSeat", "invis_absorbed" );
						--vsoTimeDelta("absorbedDelay");
						vsoNext("state_digest");
					end
				end );
			end
		end
	end
end

-------------------------------------------------------------------------------

function state_full_release()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_idle" )	--release
	end
end

-------------------------------------------------------------------------------

function state_digest()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_idle" )	--release
	end
end
