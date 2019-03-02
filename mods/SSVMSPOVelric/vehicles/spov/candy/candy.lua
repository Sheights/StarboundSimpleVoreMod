--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & http://www.furaffinity.net/user/elricmysteryshifter

--[[

Candy plan:

	Will eat people that stand in front of her randomly or you can interact to get ate
	
	Once eaten, you must squirm constantly to escape! And you only have a slim chance of her letting you escape (After some wiggles)
	
	Depending on the pills in use,
		None
			Nothing happens! Enjoy being trapped in a belly.
		Digest
			You get digested and die
		SoftDigest
			You get digested but dont die. (jump/space to escape after you are 'digested')
		Heal
			Belly heals you!
			
	Depending on the escape pills in use,
		None
			Nothing happens! You'll need at least 3 wiggles to escape.
		AntiEscape
			You'll need at least 6 consecutive wiggles to escape.
		EasyEscape
			Any number of wiggles should give you a chance to escape

]]--

require("/scripts/vore/vsosimple.lua")

--Can make this generic with a parameter in the config file...
function bodyAnim( thisanim )
	vsoAnim( "bodyState",  thisanim )
end

function doidlestuff()

	if vsoChance( 1.0/200 ) then	--1/200 chance to blink
		bodyAnim( "blink"  )
	end
	if vsoChance( 1.0/500 ) then	--1/500 chance to say something idly
		vsoSay( vsoRandomPick(  vsoVal( "idleLines" ) ) );
	end
end

-------------------------------------------------------------------------------

function onForcedReset( )

	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( true, "drivingSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	bodyAnim( "idle" )
		
	self.isSquirming = false;
			
end

-------------------------------------------------------------------------------

function onBegin()

	vsoStorageLoad();	--Load our data (asynchronous, so it takes a few frames)

	onForcedReset();
	
	vsoOnBegin( "state_idle", function()
		bodyAnim( "idle" )
		vsoClearTarget( "food" )
		vsoMakeInteractive( true )	--Hm. If we have a interactive VSO AND a interactive static thing...
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
		vsoSetTarget( "food", targetid )
		vsoNext( "state_full" )
	end )
	
	vsoOnEnd( "state_idle", function()
		vsoMakeInteractive( false )
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_full", function()
		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", {} );	--Hey, you can change this anytime! nice. "stomachacid" + "savor" will go REAL fast
		
		vsoTimerSet( "gurgle", 2.0, 10 )	--For playing sounds
		
		vsoSay( vsoRandomPick( vsoVal( "gulpLines") ) );
		vsoSound("swallow");
		
		bodyAnim( "swallow" );
		self.isSquirming = false;
		self.digestTicker = 0.0;
		self.wigglecount = 0.0;
		self.digestedtarget = false;
		
		vsoTimeDelta( "victiminside" )
		vsoSetRandomInputOverrideToDefault( "drivingSeat" );
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_release", function()
		
	end )
	
	vsoOnEnd( "state_release", function()
		
		vsoUneat( "drivingSeat" )
		vsoSetTarget( "food", nil )
		bodyAnim( "idle" )
	end )
	
end

-------------------------------------------------------------------------------

function onEnd()
	
end

-------------------------------------------------------------------------------

function state_idle()
	if vsoAnimEnd( "bodyState" ) then
		bodyAnim( "idle"  )
	end

	doidlestuff();
	
	--vsoDebugRelativeRect( 6, -3.875, 4, 2 )	--Useful to see what this means, enable /debug as /admin
	if vsoChance( 0.2 ) then
		if vsoUpdateTarget( "food", 6, -3.875, 4, 2 ) then
			vsoNext( "state_full" )
		end
	end
	
end

-------------------------------------------------------------------------------

function state_full()

	--play gurgle sounds <= "Play sound from list [soundlist] every [ 3 to 16 seconds ]"
	if vsoTimer( "gurgle" ) then
		vsoTimerSet( "gurgle", 3.0, 16.0 )
		world.spawnProjectile( "digestprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )	--Standard digest sound.
	end
	
	local anim = vsoAnimCurr( "bodyState" );
		
	if vsoAnimEnd( "bodyState" ) then
	
		if anim == "swallow" then
			
			anim = "fullidle";
			
		elseif anim == "digest" then
		
			if self.digestedtarget and vsoPill( "digest" ) then
				vsoApplyStatus( "food", "vsokillnpcsit", 1.0 )
			end
			
			anim = "idle";
			
		elseif anim == "idle" then
		
			doidlestuff();
			
		else
		
			if vsoChance( 0.1 ) then	-- 0.1 % chance to say something while someones in the belly
				vsoSay( vsoRandomPick( vsoVal( "bellyLines" ) ) );
			end
			
			if anim == "fullidle" then
			
				if vsoChance( 5 ) then	-- 5 % chance to move belly around (1/20)
				
					anim = vsoRandomPick( { "fullidle1", "fullidle2", "fullidle3", "fullidle4", "fullidle5", "fullidle6", "fullidle7" } )
				
					vsoSound( vsoRandomPick( { "belly1", "belly2", "belly3" } ) )
				end
				
			else
			
				anim = "fullidle"
			end
			
		end
		
		bodyAnim( anim )
	end
	
	--SPO's can be escaped EASILY...	<= "if victim escapes like spo, go to [ "idle" ]"
	local isSquirmingChanged = false;
	if vsoHasAnySPOInputs( "drivingSeat" ) or not vsoHasEaten( "drivingSeat" ) then
	
		if self.isSquirming then
			--ignore
		else
			isSquirmingChanged = true;
			self.isSquirming = true;
		end
	else
		self.isSquirming = false;
	end
	
	--Edge tracking for squirming
	if isSquirmingChanged then
	
		if self.digestedtarget and anim ~= "digest" then
			
			vsoNext( "state_release" )	--release
		
		else
	
			if anim == "fullidle" then
		
				self.wigglecount = self.wigglecount + 1.0;
			
				--Handle escape-related pills
				local wigglesneeded = 3;
				if vsoPill("antiescape") then
					wigglesneeded = wigglesneeded + 3 * ( vsoPillValue("antiescape") or 1.0 );
				end
				if vsoPill("easyescape") then
					wigglesneeded = wigglesneeded - 3 * ( vsoPillValue("easyescape") or 1.0 );
				end
				
				if vsoChance( 80 ) or (self.wigglecount < wigglesneeded) then	-- 80% chance of DENIAL
				
					bodyAnim(  vsoRandomPick( { "fullidle5", "fullidle6", "fullidle7" } ) )
				
					vsoSay( vsoRandomPick(  vsoVal( "keepInsideLines" ) ) );
						
					vsoSound( vsoRandomPick( { "belly1", "belly2", "belly3" } ) )
							
				else
				
					bodyAnim( "regurgitate" );
					vsoSay( vsoRandomPick(  vsoVal( "releaseLines" ) ) );
					vsoNext( "state_release" )	--release
					
				end
			end
		end
	elseif not self.digestedtarget then
	
		if self.wigglecount > 0 then
			self.wigglecount = self.wigglecount - vsoDelta()/2.0;
		else
			self.wigglecount = 0.0;
		end
		
		--Simple NPC behaviour list:
		if vsoPill("digest") or vsoPill("softdigest") then
			
			vsoSetRandomInputOverrideToFight( "drivingSeat" );	--Dont digest me!!!
		elseif vsoPill("heal") then
			
			if victimhealthpercent > 99 then	--Only fight to get out after we are healed
				vsoSetRandomInputOverrideToFight( "drivingSeat" );
			else
				vsoSetRandomInputOverrideToPlease( "drivingSeat" );
			end
		else
			
			if vsoTimeDelta( "victiminside", true ) > 5.0 then	--Struggles become more intense 5 seconds later?
				vsoSetRandomInputOverrideToFight( "drivingSeat" );
			end
		end
		
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
			local digestDamage = -1 * self.digestTicker * digestRate;
			if math.abs(digestDamage) >= 1.0 then
				self.digestTicker = 0.0;
				
				if self.digestedtarget then
					--DID we?
				else
					if not vsoPill("softdigest") then
						--Ends in the death of the victim!
						vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", digestDamage, 0, function(stillhealthy)
							if not stillhealthy then
								bodyAnim( "digest" )
								vsoAnimEnd( "bodyState" )	--Not sure if this fixes a problem...
								self.digestedtarget = true;
							end
						end );
					else
						--Victim gets to stick around
						vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", digestDamage, 0, function(stillhealthy)
							if not stillhealthy then
								if digestDamage < 0 then	--Victim is down to 0 HP, but still has to struggle out
									bodyAnim( "digest" )
									vsoAnimEnd( "bodyState" )	--Not sure if this fixes a problem...
									self.digestedtarget = true;
								end
							end
						end );
					end
				end
			end
		end
	end
	
	if not vsoTargetIsEaten( "food" ) then
		vsoNext( "state_release" );
	end
end

-------------------------------------------------------------------------------

function state_release()

	if vsoAnimEnd( "bodyState" ) then
		
		bodyAnim( "idle" );
	end
	
	if vsoAnimCurr( "bodyState" ) == "regurgitate" then
		
	else
		if vsoVictimAnimClearReady( "drivingSeat" ) then
			vsoNext( "state_idle" )	--release
		end
	end
	
end
	