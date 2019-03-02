--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & http://www.furaffinity.net/user/elricmysteryshifter

require("/scripts/vore/vsosimple.lua")

--[[

Val plan:

	Get ate by interacting
	
	Struggle around, if you do this quickly you get released
	Otherwise it is pleasing struggles!
	
	Once you go past the first belly there is no escape?
	
	Then you just have to wait? Hm. This only occurs if val is digesting in some way.
	
	When inside val,
		struggle by tapping a direction,
		please by holding a direction
	Both count as escape options, so mash buttons to escape!
	
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
			at least 3 consecutive wiggles about
		AntiEscape
			needs 6 or more consecutive wiggles
		EasyEscape
			just 1 or so wiggles escapes
	
]]--

-------------------------------------------------------------------------------

function onForcedReset( )

	vsoAnimSpeed( 1.0 );
	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( true, "drivingSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_idle" )
	vsoAnim( "bodyState", "idle" )
end

-------------------------------------------------------------------------------

function onBegin()

	vsoStorageLoad();	--Load our data (asynchronous, so it takes a few frames)

	onForcedReset();
	
	vsoOnBegin( "state_idle", function()
	
		vsoAnim( "bodyState", "idle" )
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
		
		vsoVictimAnimSetStatus( "drivingSeat", {} );	--Any status you like. "voreheal", "savor", "nude"
		
		vsoTimerSet( "gurgle", 2.0, 10 )	--For playing sounds
		
		vsoAnimSpeed( 1.0 );
		vsoSay( "*gulp*" );
		vsoSound("swallow");
		
		self.digestTicker = 0;
		self.digestedtarget = false;
		self.escapewiggles = 0;
		
		vsoTimeDelta( "victiminside" )
		vsoSetRandomInputOverrideToDefault( "drivingSeat" );
			
		vsoAnim( "bodyState", "swallow" );
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_release", function()

	end )
	
	vsoOnEnd( "state_release", function()
		
		vsoUneat( "drivingSeat" )
		vsoSetTarget( "food", nil )
		vsoAnim( "bodyState", "idle" )
	end )
	
end

-------------------------------------------------------------------------------

function onEnd()
	
end

-------------------------------------------------------------------------------

function state_idle()
	if vsoAnimEnd( "bodyState" ) then
		vsoAnimSpeed( 1.0 );
		vsoAnim( "bodyState",  "idle"  )
	end
	if vsoChance( 1 ) then
		vsoAnim( "bodyState",  "blink"  )
	end
end

-------------------------------------------------------------------------------

function state_full()

	--play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
	if vsoTimer( "gurgle" ) then
		vsoTimerSet( "gurgle", 1.0, 8.0 )
		vsoSound( "digest" )
	end
	
	local victimhealthpercent = vsoGetHealthPercent( "drivingSeat" )
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
	
		vsoAnimSpeed( 1.0 );
		
		if anim == "swallow" then
			
			anim = "fullbig";
		elseif anim == "fullbig" then
		
			--"Move down" logic? time if digest, health if digest, nomovedown if heal?
			if (self.digestedtarget or victimhealthpercent < 70) and ( vsoPill("digest") or vsoPill("softdigest") ) then
			
				vsoSound("belly1")
				anim = "bigtosmall";
			end
		elseif anim == "bigsquirml" then
			anim = "fullbig";
		elseif anim == "bigsquirmr" then
			anim = "fullbig";
		elseif anim == "bigtosmall" then
		
			anim = "fullsmall";
		elseif anim == "fullsmall" then
		
			--"Move down" logic? time if no digest, health if digest?
			if self.digestedtarget or victimhealthpercent < 40 then
			
				vsoSound("belly2")
				anim = "smalltomicro";
			end
		elseif anim == "smallsquirml" then
			anim = "fullsmall";
		elseif anim == "smallsquirmr" then
			anim = "fullsmall";
		elseif anim == "smalltomicro" then
		
			anim = "fullmicro";
		elseif anim == "fullmicro" then
		
			--"Move down" logic? time if no digest, health if digest?
			if self.digestedtarget or victimhealthpercent < 10 then
			
				vsoSound("belly3")
				anim = "microtonone";
				self.digestedtarget = true;
			end
		elseif anim == "microsquirml" then
			anim = "fullmicro";
		elseif anim == "microsquirmr" then
			anim = "fullmicro";
		elseif anim == "microtonone" then
		
			--Hm...
			vsoVictimAnimSetStatus( "drivingSeat", {} );-- "savor", "nude" } );	--Hey, you can change this anytime! nice.
		
			if self.digestedtarget and vsoPill( "digest" ) then	--Hm.
				vsoApplyStatus( "food", "vsokillnpcsit", 1.0 )
			end
			
			anim = "idle";
		elseif anim == "nonetomicro" then
			anim = "fullmicro";
		elseif anim == "microtosmall" then
			anim = "fullsmall";
		elseif anim == "smalltobig" then
			anim = "fullbig";
		
		elseif anim == "idle" then
		
			--This is a bit awkward... we swallowed someone and "digested" them, but.
			--Are we able to eat someone else without ejecting the victim? Does the victim have to leave/die?
			--Huh...
		end
	
		vsoAnim( "bodyState",  anim )
		
	else
		--This stuff is updated when an animation has NOT finished
		
		local isescaping = false;
		local canescape = false;
		local movetype,movedir = vso4DirectionInput( "drivingSeat" );
		local usespeed = 1.0;
		local nextanim = nil;
		
		if anim == "fullbig" then
			--squirming 
			
			--Needs a bit more convincing!
			if movedir == 'B' then
				nextanim = "bigsquirml"
				usespeed = 2.0/movetype;
				if movetype == 1 then
					self.escapewiggles = self.escapewiggles + 1;
				end
			elseif movedir == 'F' then
				nextanim = "bigsquirmr"
				usespeed = 2.0/movetype;
				if movetype == 1 then
					self.escapewiggles = self.escapewiggles + 1;
				end
			elseif movedir == 'D' then
				
				nextanim = "bigsquirmr"
				usespeed = 2.0/movetype;
				
				if movetype == 1 then
					self.escapewiggles = self.escapewiggles + 1;
				end
				
			elseif (movedir == 'J' or movedir == 'U') then
				
				local wigglesneeded = 3;
				if vsoPill("antiescape") then
					wigglesneeded = wigglesneeded + 3 * ( vsoPillValue("antiescape") or 1.0 );
				end
				if vsoPill("easyescape") then
					wigglesneeded = wigglesneeded - 3 * ( vsoPillValue("easyescape") or 1.0 );
				end
				
				if movetype == 1 then
					self.escapewiggles = self.escapewiggles + 1;
				end
				
				if self.escapewiggles > wigglesneeded then
					isescaping=true;
					canescape = true;
				else
					nextanim = "bigsquirml"
					usespeed = 2.0/movetype;
				end
				
			else
				if self.escapewiggles < 0 then	--not wigglin eh? AND playing fullbig?
					self.escapewiggles = 0;
				else
					self.escapewiggles = self.escapewiggles - vsoDelta()/2.0;
				end
			end
		elseif anim == "fullsmall" then
			--squirming 
			if movedir == 'B' then
				nextanim = "smallsquirml"
				usespeed = 2.0/movetype;
			elseif movedir == 'F' then
				nextanim = "smallsquirmr"
				usespeed = 2.0/movetype;
			elseif movedir == 'D' then
				nextanim = "smallsquirmr"
				usespeed = 2.0/movetype;
			elseif (movedir == 'J' or movedir == 'U') then
				nextanim = "smallsquirml"
				usespeed = 2.0/movetype;
			else
				--canescape = true;
			end
		elseif anim == "fullmicro" then
			--squirming 
			if movedir == 'B' then
				nextanim = "microsquirml"
				usespeed = 2.0/movetype;
			elseif movedir == 'F' then
				nextanim = "microsquirmr"
				usespeed = 2.0/movetype;
			elseif movedir == 'D' then
				nextanim = "microsquirmr"
				usespeed = 2.0/movetype;
			elseif (movedir == 'J' or movedir == 'U') then
				nextanim = "microsquirml"
				usespeed = 2.0/movetype;
			else
				--canescape = true;
			end
		elseif anim == "idle" then
			if (movedir == 'J' or movedir == 'U') then
				if self.digestedtarget or victimhealthpercent < 10 then
					if not vsoPill( "digest" ) then
						vsoAnim( "bodyState", "idle" );
						vsoNext( "state_release" )	--release
					end
				end
			end
		end
		
		if canescape then
			isescaping = true;
		end
		
		if isescaping or not vsoHasEaten( "drivingSeat" ) then
					
			vsoAnim( "bodyState", "release" );
			vsoSay( "*hork*" );
			vsoSound("lay");
			
			vsoNext( "state_release" )	--release
			
		elseif nextanim ~= nil then
			vsoAnim( "bodyState",  nextanim )
			vsoAnimSpeed( usespeed );
		end
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
		if vsoTimeDelta( "victiminside", true ) > 5.0 then	--Struggles become more intense 5 seconds later
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
		
			if vsoPill("digest") and ( victimhealthpercent >= 10 ) then
				--Ends in the death of the victim!
				vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", digestDamage, 0, function(stillhealthy)
					if not stillhealthy then
						self.digestedtarget = true;
					end
				end );
			elseif not vsoPill("softdigest") then
				--Ends in the death of the victim!
				vsoResourceAddPercent( vsoGetTargetId("food"), "health", digestDamage, function(stillalive)
					if not stillalive then
						self.digestedtarget = true;
					end
				end );
			else
				if self.digestedtarget then
					--DID we? well stop then!
				else
					--Victim gets to stick around
					vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", digestDamage, 0, function(stillhealthy)
						if not stillhealthy then
							if digestDamage < 0 then	--Victim is down to 0 HP, but still has to struggle out
								self.digestedtarget = true;
							end
						end
					end );
				end
			end
		end
	end
	
end

-------------------------------------------------------------------------------

function state_release()
	if vsoAnimEnd( "bodyState" ) then
		
		vsoAnim( "bodyState", "idle" );
	end
	
	if vsoAnimCurr( "bodyState" ) == "release" then
		
	else
		if vsoVictimAnimClearReady( "drivingSeat" ) then
			vsoNext( "state_idle" )	--release
		end
	end
end
	