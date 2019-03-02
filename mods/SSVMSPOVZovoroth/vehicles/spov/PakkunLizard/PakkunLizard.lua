--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ Zovoroth

require("/scripts/vore/vsosimple.lua")

--[[

Pakkun Lizard plan:

	A little lizard that uses its long, sticky tongue to eat anyone who gets close!

	It will occasionally walk around in a small area near where it is spawned.

	If any player or NPC gets close, it will occasionally try to eat them.
		If they are close, it will just open its mouth.
		If they are far, it will extend its tongue towards them.

	If its mouth is open, it will swallow anyone who gets too close or stands on its head.

	If its tongue is extending, the first person to touch it will get stuck to it. They will be pulled in and swallowed.
		Only the tip of the tongue is dangerous, and it's safe to touch once it begins to retract.

	If you are swallowed, you can struggle to get free by pressing any button.
		Keep up the pressure to escape!

	If it takes damage after swallowing someone, it will immediately release them!

	If it is injured, it will occasionally cast Cure Water, which heals it.
		There is a limit to how often this can be cast.

	Future things:
	--------------
	Upward eat animation.
	Actual eating animation.
	Only show hurt animation if taking a certain amount of damage in a short period of time.
	Only release swallowed prey on taking damage if the damage exceeds a certain amount (at once or in a period of time).
	Game lore says that they will eat things even when they aren't hungry. Maybe if it's not hungry, it automatically regurgitates after a short while?
	Maybe eat fish and meat? Maybe eat any food at all (except for chocolate).
	Maybe produces chocolate at random if well fed? (The game developers came up with it, not me!)
	
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

function setSolid( collisionName ) --helper function to set which collisions to use
	local bodyCol = collisionName == "body";
	local headCol = collisionName == "head";
	local headHurtCol = collisionName == "head_hurt";
	local headFullCol = collisionName == "head_full";

	vsoUseSolid(bodyCol, "body");
	vsoUseSolid(headCol, "head");
	vsoUseSolid(headHurtCol, "head_hurt");
	vsoUseSolid(headFullCol, "head_full");
end

function handleDamage( damageRequest )
	local anim = vsoAnimCurr( "bodyState" );

	if anim == "full" or string.sub(anim,1,6) == "squirm" then
		--Spit prey out
		vsoNext( "state_release" );
	elseif anim == "eat" or anim == "swallow" or anim == "digest" then
		--Ignore it!
	else
		--Get visibly hurt!
		vsoNext( "state_hurt" );
	end

	--He's dead!
	if storage.health - damageRequest.damage <= 0 then
		damageRequest.damage = 0;
		vsoAnim("bodyState", "dead");
		vsoNext("state_dead");
	end

	return damageRequest;
end

function absorbEscape()
	if vsoHasEaten("absorbedSeat") and vsoTimeDelta("absorbedDelay", true) >= 3.0 then
		local movetype,movedir = vso4DirectionInput( "absorbedSeat" );
		--NPCs automatically escape
		if movetype == -1 then
			movetype = 1;
			movedir = "F";
		end

		--Any button press will release you
		if movetype > 0 then
			vsoUneat("absorbedSeat");
		end
	end
end

-------------------------------------------------------------------------------

function onForcedReset( )	--helper function. If a victim warps, vanishes, dies, force escapes, this is called to reset me. (something went wrong) 

	vsoAnimSpeed( 1.0 );
	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( false, "drivingSeat" )
	vsoVictimAnimVisible( "absorbedSeat", false )
	vsoUseLounge( false, "absorbedSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	vsoAnim( "bodyState", "idle" )
	vsoAnim( "tongue", "empty" )
	
	vsoMakeInteractive( false )
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.

	vsoEffectWarpIn();	--Play warp in effect
	
	onForcedReset();	--Do a forced reset once.
	
	vsoStorageLoad( loadStoredData );	--Load our data (asynchronous, so it takes a few frames)

	vsoSetDeathOptions({ smash = true });	--Break the spawner if you kill it

	vsoTimeDelta("eatAttempt");

	vsoTimeDelta("mpRegen");
	self.mp = 30.0;			--Used to heal
	self.mpMax = 30.0;
	self.cureCost = 15.0;
	
	---------------------------------------------------------------------------
	--state_idle
	----
	--Pakkun stands around, acting cute.
	--If you get close, it will try to eat you.

	vsoOnBegin( "state_idle", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "idle" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
		
	end )
	
	vsoOnEnd( "state_idle", function()
	
	end )

	vsoOnDamage( "state_idle", handleDamage );

	---------------------------------------------------------------------------
	--state_walk
	----
	--Pakkun walks around at random in a small area.

	vsoOnBegin( "state_walk", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "walk" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )
		
		vsoMotionParam( { walkSpeed=3, runSpeed=3 } )
		vsoActWanderNear( vsoGetSpawnPosition(), 5 );
	end )

	vsoOnEnd( "state_walk", function()
		vsoActClear();
	end )

	vsoOnDamage( "state_walk", handleDamage );

	---------------------------------------------------------------------------
	--state_cure
	----
	--Pakkun casts Cure Water on itself, healing it.
	--During this time, it can't be hurt!

	vsoOnBegin( "state_cure", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "idle" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		self.mp = math.min(self.mp + vsoTimeDelta("mpRegen"), self.mpMax) - self.cureCost;
		self.cureAmount = 30;

		vsoTimeDelta("curePhase");
		vsoSound("magic");
		animator.burstParticleEmitter("curewater");
	end )
	
	vsoOnEnd( "state_cure", function()
		vsoSetDirectives(vsoMakeColorReplaceDirectiveString(storage.colorReplaceMap));
	end )

	---------------------------------------------------------------------------
	--state_eat
	----
	--Pakkun leans forward, mouth open.
	--Get close to it and it will swallow you (state_swallow).

	vsoOnBegin( "state_eat", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "eat" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoFaceTarget("prey");

		vsoTimeDelta( "eatDelay" );			--Delay before swallow "hitbox"
		vsoTimerSet( "giveUp", 0.5, 2.0 );	--Transition back to state_idle
	end )

	vsoOnDamage( "state_eat", handleDamage );

	---------------------------------------------------------------------------
	--state_tongue_extend
	----
	--Pakkun extends its tongue.
	--Once it fully extends, it will retract.
	--Touch it and you will get stuck to it.

	vsoOnBegin( "state_tongue_extend", function()
		vsoUseLounge( true, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "eat" )
		vsoAnim( "tongue", "extend" )
		vsoMakeInteractive( false )

		vsoFaceTarget("prey")
		vsoSound("slurp");

		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnim( "drivingSeat", "tongue_extend", "tongue" )
	end )

	vsoOnDamage( "state_tongue_extend", handleDamage );

	---------------------------------------------------------------------------
	--state_tongue_retract
	----
	--Pakkun retracts its tongue.
	--Stuck victims remain stuck, but new victims will not stick.
	--If a victim is stuck, once it retracts, they will be swallowed (state_swallow).

	vsoOnBegin( "state_tongue_retract", function()
		vsoUseLounge( true, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "eat" )
		vsoAnim( "tongue", "retract" )
		vsoMakeInteractive( false )

		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnim( "drivingSeat", "tongue_retract", "tongue" )
	end )

	vsoOnDamage( "state_tongue_retract", handleDamage );
	
	---------------------------------------------------------------------------
	--state_swallow
	----
	--Pakkun holds victim in mouth, swallowing them after a brief delay.

	vsoOnBegin( "state_swallow", function()
		vsoUseLounge( true, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "swallow"  )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoVictimAnimVisible( "drivingSeat", false )
		vsoVictimAnim( "drivingSeat", "invis" )

		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatemaw" } );

		vsoTimerSet( "swallow", 0.2, 1.0 )	--Transition to state_full
	end )

	vsoOnEnd( "state_swallow", function()
	end )

	vsoOnDamage( "state_swallow", handleDamage );

	---------------------------------------------------------------------------
	--state_full
	----
	--Pakkun sits with a full belly.
	--The victim can struggle to get free.
	--If it is attacked, it will release the victim.

	vsoOnBegin( "state_full", function()
		vsoUseLounge( true, "drivingSeat" )
		vsoUseLounge( true, "absorbedSeat" )
		setSolid("head_full");
		vsoAnim( "bodyState", "full"  )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )
		
		vsoVictimAnimVisible( "drivingSeat", false )
		vsoVictimAnim( "drivingSeat", "invis" )

		vsoCounterReset( "squirming" );
		self.digestTicker = 0.0;
		self.squirmMinimum = 5;
		self.squirmMaximum = 15;
		--Handle escape-related pills
		if vsoPill("antiescape") then
			local multiplier = vsoPillValue("antiescape") or 1.0;
			self.squirmMinimum = math.floor(self.squirmMinimum + (multiplier * 5.0));
			self.squirmMaximum = math.floor(self.squirmMaximum + (multiplier * 10.0));
		end
		if vsoPill("easyescape") then
			local multiplier = vsoPillValue("easyescape") or 1.0;
			self.squirmMinimum = math.max(math.floor(self.squirmMinimum - (multiplier * 3.0)), 0);
			self.squirmMaximum = math.max(math.floor(self.squirmMaximum - (multiplier * 10.0)), 0);
		end

		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatebelly" } );

		vsoSetTargetable( 0, -3, "body" );	--CAREFUL. position is static so if you are moving, change this.
		
		vsoTimerSet( "gurgle", 1.0, 8.0 )	--For playing sounds
	end )

	vsoOnEnd( "state_full", function()
		vsoClearTargetable( "body" );
	end )

	vsoOnDamage( "state_full", handleDamage );

	---------------------------------------------------------------------------
	--state_digest
	----
	--Pakkun's belly shrinks, then it looks down and is confused.
	--"How did this happen? I didn't spit them out..."

	vsoOnBegin( "state_digest", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head");
		vsoAnim( "bodyState", "digest"  )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoUneat( "drivingSeat" )
		vsoClearTarget( "food" )
		vsoClearTarget( "prey" )
	end )

	vsoOnEnd( "state_digest", function()

	end )

	vsoOnDamage( "state_digest", handleDamage );
	
	---------------------------------------------------------------------------
	--state_release
	----
	--Pakkun spits the victim out.

	vsoOnBegin( "state_release", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head_full");
		vsoAnim( "bodyState", "hurtfull" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoSound("lay")

		vsoUneat( "drivingSeat" )
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked"
		vsoClearTarget( "food" )
	end )
	
	vsoOnEnd( "state_release", function()
		vsoTimeDelta("eatAttempt");
	end )

	---------------------------------------------------------------------------
	--state_hurt
	----
	--Pakkun is in pain!
	--Also releases any victims.

	vsoOnBegin( "state_hurt", function()
		vsoUseLounge( false, "drivingSeat" )
		setSolid("head_hurt");
		vsoAnim( "bodyState", "hurt" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoUneat( "drivingSeat" )
		vsoClearTarget( "food" )
	end )

	---------------------------------------------------------------------------
	--state_dead
	----
	--You monster!
	--Also releases any victims... just in case!

	vsoOnBegin( "state_dead", function()
		vsoUseLounge( false, "drivingSeat" )
		vsoUseSolid(false);
		vsoAnim( "bodyState", "dead" )
		vsoAnim( "tongue", "empty" )
		vsoMakeInteractive( false )

		vsoUneat( "drivingSeat" )
		vsoUneat( "absorbedSeat" )
		vsoClearTarget( "food" )
	end )

end

-------------------------------------------------------------------------------

function onEnd()
	
	vsoEffectWarpOut();
	
end

-------------------------------------------------------------------------------

function state_idle()
	absorbEscape();

	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		if vsoTimerEvery( "walkTimer", 1.0, 5.0 ) then
			vsoAnim("bodyState", "walk");
			vsoNext( "state_walk" );
		else
			vsoAnim( "bodyState",  "idle"  )
		end
	end

	if storage.health <= 70 and vsoChance(2) and self.mp + vsoTimeDelta("mpRegen",true) >= self.cureCost then
		vsoNext("state_cure");
		return; --Don't try to eat anything
	end

	--Find a target roughly in range
	vsoUpdateTarget("prey", -8.0, -4.0, 8.0, 1.0, { order = "random" });
	vsoDebugRelativeRect(-8.0, -4.0, 8.0, 1.0, "red");

	--Break target if there's no clear path to it
	if vsoValidTarget("prey") then
		local predPosition = vec2.add(mcontroller.position(), {0.0, -2.5});
		local preyPosition = vec2.add(world.entityPosition(vsoGetTargetId("prey")), {0.0, -1.0});
		vsoDebugLine(predPosition[1], predPosition[2], preyPosition[1], preyPosition[2], "green");
		if world.lineTileCollision(predPosition, preyPosition, {"block"} ) then
			vsoClearTarget("prey");
		end
	end

	--Check the cooldown timer
	if vsoValidTarget("prey") and vsoTimeDelta("eatAttempt", true) > 3.0 then
		local xDistance = math.abs(world.entityPosition(vsoGetTargetId("prey"))[1] - mcontroller.xPosition());

		--If close, eat directly. Otherwise, use tongue
		if xDistance <= 2.0 then
			vsoTimeDelta("eatAttempt");
			vsoNext( "state_eat" );
		elseif xDistance <= 8.0 then
			vsoTimeDelta("eatAttempt");
			vsoNext( "state_tongue_extend" );
		end
	end
end

-------------------------------------------------------------------------------

function state_walk()
	absorbEscape();
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		if vsoTimerEvery( "walkTimer", 1.0, 5.0 ) then
			vsoAnim("bodyState", "idle");
			vsoNext( "state_idle" );
		else
			vsoAnim("bodyState", "walk");
		end
	end

	if storage.health <= 70 and vsoChance(2) and self.mp + vsoTimeDelta("mpRegen",true) >= self.cureCost then
		vsoNext("state_cure");
		return; --Don't try to eat anything
	end

	--Find a target roughly in range
	vsoFindTarget("prey", -6.0, -4.0, 6.0, 1.0, { order = "nearest" });
	vsoDebugRelativeRect(-6.0, -4.0, 6.0, 1.0, "red");

	--Probably try to get them!
	if vsoValidTarget("prey") and vsoTimeDelta("eatAttempt", true) > 3.0 and vsoChance(5) then
		vsoNext("state_idle");
	end
end

-------------------------------------------------------------------------------

function state_cure()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim("bodyState", "idle");
	end

	if vsoTimeDelta("curePhase", true) >= 1.5 then
		storage.health = math.min(storage.health + self.cureAmount, 100);
		vsoNext("state_idle");
	elseif vsoTimeDelta("curePhase", true) >= 0.3 then
		local colorRed = math.random(100);
		local colorGreen = 100 + math.random(155);
		local colorBlue = 230 + math.random(25);
		vsoSetDirectives("setcolor="..string.format("%02x%02x%02x", colorRed, colorGreen, colorBlue));
	else
		--Particle animation is playing
	end
end

-------------------------------------------------------------------------------

function state_eat()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState",  "eat"  )
	end

	--A short delay before activating the hit box
	if vsoTimeDelta("eatDelay", true) >= 0.3 then
		--Try to eat anyone who comes close
		vsoUpdateTarget("food", -0.5, -3.5, 2.0, -0.5, { order = "nearest" });
		vsoDebugRelativeRect(-0.5, -3.5, 2.0, -0.5, "red");

		if vsoValidTarget( "food" ) then
			vsoNext( "state_swallow" );
		end
	end

	--Give up after a little bit
	if not vsoHasEaten("drivingSeat") and vsoTimer( "giveUp" ) then
		vsoClearTarget("prey");
		showEmote("emotesad");
		vsoNext( "state_idle" );
	end
end

-------------------------------------------------------------------------------

function state_tongue_extend()
	
	local anim = vsoAnimCurr( "bodyState" );
	local tAnim = vsoAnimCurr( "tongue" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState",  "eat"  )
	end

	if vsoAnimEnd( "tongue" ) then
		vsoNext( "state_tongue_retract" )
	end

	--Check at end of tongue
	if not vsoHasEaten("drivingSeat") then
		--Get offsets for the tip of the tongue
		local tongueFrame = math.floor(vsoAnimTime("tongue") * 11.0 / 0.5 + 1); --1-12
		local tonguePositionOffset = vsoVal("tonguePositions")[tongueFrame];
		local tongueOffset = vsoVal("tongueOffset");

		--Calculate the final position
		local offset = vec2.add(tongueOffset, tonguePositionOffset);

		--Put a small hitbox at the tip of the tongue
		vsoUpdateTarget("food", offset[1]-0.5, offset[2], offset[1]+0.5, offset[2]+1.0)
		vsoDebugRelativeRect(offset[1]-0.5, offset[2], offset[1]+0.5, offset[2]+1.0, "red")

		if vsoValidTarget("food") then
			--Break target if no line of sight!
			local predPosition = vec2.add(mcontroller.position(), {0.0, -2.5});
			local preyPosition = vec2.add(world.entityPosition(vsoGetTargetId("food")), {0.0, -1.0});
			vsoDebugLine(predPosition[1], predPosition[2], preyPosition[1], preyPosition[2], "green");
			if world.lineTileCollision(predPosition, preyPosition, {"block"} ) then
				vsoClearTarget("food");
			else
				--Got 'em!
				vsoEat( vsoGetTargetId( "food" ), "drivingSeat" );
			end
		end
	end
	
end

-------------------------------------------------------------------------------

function state_tongue_retract()
	
	local anim = vsoAnimCurr( "bodyState" );
	local tAnim = vsoAnimCurr( "tongue" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState",  "eat"  )
	end

	--This should prevent two vsos from eating someone at the same time
	if not vsoTargetIsEaten( "food" ) then
		if vsoAnimEnd( "tongue" ) then
			vsoUneat( "drivingSeat" );
			showEmote( "emotesad" );
			vsoNext( "state_idle" );
		end
	else
		if vsoAnimEnd( "tongue" ) then
			vsoNext( "state_swallow" );
		end
	end
end

-------------------------------------------------------------------------------

function state_swallow()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		vsoAnim( "bodyState",  "swallow"  )
	end

	--In case prey somehow leaves
	if not vsoTargetIsEaten( "food" ) then
		vsoUneat( "drivingSeat" );
		showEmote( "emoteconfused" );
		vsoNext( "state_idle" );
	end

	if vsoTimer( "swallow" ) then
		showEmote("emotehappy");
		vsoSound( "swallow" );
		vsoNext( "state_full" );
	end
end

-------------------------------------------------------------------------------

function state_full()
	absorbEscape();

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
		vsoNext( "state_digest" );
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
				nextanim = vsoPick( {"squirmF","squirmB","squirmU","squirmD"} );
			end

			vsoAnim("bodyState", nextanim);
			vsoSound( "struggle" );

			if vsoCounterChance( "squirming", self.squirmMinimum, self.squirmMaximum ) then
				vsoNext( "state_release" )	--release
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
		local digestDamage = -3.0 * self.digestTicker * digestRate;
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
						vsoUneat("absorbedSeat");
						vsoEat(vsoGetTargetId("food"), "absorbedSeat");
						vsoVictimAnim( "absorbedSeat", "invis_absorbed" );
						vsoTimeDelta("absorbedDelay");
						vsoNext("state_digest");
					end
				end );
			end
		end
	end
end

-------------------------------------------------------------------------------

function state_digest()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
		if anim == "digest" then
			vsoAnim( "bodyState", "lookdown" );
			--OVerrides the delay, in case digestion happens too quickly
			animator.setParticleEmitterBurstCount( "emoteconfused", 1 );
			animator.burstParticleEmitter( "emoteconfused" )
		elseif anim == "lookdown" then
			vsoNext("state_idle");
		end
	end
end

-------------------------------------------------------------------------------

function state_release()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_idle" )	--release
	end
end

-------------------------------------------------------------------------------

function state_hurt()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoNext( "state_idle" )
	end
end

-------------------------------------------------------------------------------

function state_dead()
	if vsoVictimAnimClearReady( "drivingSeat" ) and vsoAnimEnd( "bodyState" ) then
		vsoForceDeath();--vehicle.destroy();
	end
end
