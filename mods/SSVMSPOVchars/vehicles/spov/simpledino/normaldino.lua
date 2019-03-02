--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo

require("/scripts/vore/vsosimple.lua")

--[[

normaldino plan:

	Idly waits for you to feed it meat!
	
	If you are holding meat (in front of it), it will stand more at attention (happy you have some)
	
	You can interact with the dino to feed it by hand if you are holding a steak (always a good thing and it loves this the most)
	
	Tease it with a steak too long and it will take a bite at you
		
	Drop the item in front of it and it will eat the item (happily)
		<- if you take it away, it gets upset (dont let it miss)
	
	Interacting with it will cause it to respond (But it is position sensitive, so stand in front)
		Happy, gives you a lick. (if you are already licked, it might eat you!)
		Not so happy, it complains
		Unhapppy, it might just eat you.
		Not in range, it will speak at you
		
	Its mood should be obvious by its appearance and what it says. It's directly correlated to it's belly fullness.
	
	If it's upset, it might just nab anything that walks by.
	
	If it's too upset, you can't even hand feed it!
	
	If you (or an npc) gets ate, you can wiggle to escape (tapping buttons)
		Or, you can HOLD buttons to please/massage the beast.
		This currently doesn't do much (will make it do something later)
		And you have to wiggle a bit to escape so dont give up!

]]--

function loadStoredData()

	vsoEffectWarpIn();	--Play warp in effect
	
	vsoStorageSaveAndLoad( function()	--Get defaults from the item spawner itself
	
		--sb.logInfo( "Did we get color replace map?"..tostring(storage.colorReplaceMap) )
		if storage.colorReplaceMap ~= nil then
			vsoSetDirectives( vsoMakeColorReplaceDirectiveString( storage.colorReplaceMap ) );
		end
	end )
	
end

function chatterIdly()	--Helper function (make lots of these) to speak based on belly fullness

	local anim = vsoAnimCurr( "bodyState" );
	if anim ~= "chatter" then
	
		if storage.belly > 80 then
		
			vsoAnitagAnim()	--Hm...
			vsoAnim( "bodyState",  "full2" );	--Hm!
			vsoSay( vsoPick( {
				"rrrr...\n(Sooo full)" 
				,"mmrrr...\n(Stuffed)" 
				,"rrmmrr...\n(Too full)" 
			} ) );
			vsoSound( "purr" );
		
		elseif storage.belly > 50 then
		
			vsoAnitagAnim()	--Hm...
			vsoAnim( "bodyState",  "chatter" );
			vsoSay( vsoPick( {
				"rrr~\n(I'm full)" 
				,"rrrmm~\n(Nice and full)" 
				,"mmm~\n(Full)" 
			} ) );
			vsoSound( "purr" );
			
		elseif storage.belly > 30 then
		
			vsoAnitagAnim()
			vsoAnim( "bodyState",  "chatter" );
			vsoSay( vsoPick( {
				"Rrawr rr~\n(Do you have meat?)" 
				,"rrr, rrr~\n(Can I have some meat?)" 
				,"Grr, rawrr rr~\n(I'd like some meat.)" 
			} ) );
			vsoSound( "chatter" );
		
		elseif storage.belly > 0 then
		
			vsoAnitagAnim()
			vsoAnim( "bodyState",  "chatter" );
			vsoSay( vsoPick( {
				"Grawr rawr~\n(Feed me meat!)" 
				,"Snarl, rrr~\n(Give me meat!)" 
				,"Grr, awrr rr~\n(I want meat!)" 
			} ) );
			vsoSound( "chatter" );
			
		else
		
			vsoAnitagAnim()
			vsoAnim( "bodyState",  "chatter" );
			vsoSay( vsoPick( {
				"Snarl!\n(I'm starving!)" 
			} ) );
			vsoSound( "biteready" );
		end
		
	end

end

function changeFeedStat( method, key, delta )	--helper function to change a statistic we are storing.
	vsoAddStoredStat( "feedstats", method, key, delta );
end

function changeBellyStat( delta )	--helper function to change our belly storage
	storage.belly = storage.belly + delta;
	vsoStorageSaveKey( "belly" );
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
	
	self.foodtargetid = nil;
	self.foodtargetname =  nil;
	self.victimhadsteak = 0;
	
	vsoMakeInteractive( true )
end

-------------------------------------------------------------------------------

function onBegin()	--This sets up the VSO ONCE.

	vsoSetDeathOptions( { smash = true; } )	-- { respawn = 3; } { smash = true; permadeath = true }

	onForcedReset();	--Do a forced reset once.
	
	storage.belly = 30;	--SOME values need to be specified to avoid /reload errors (annoying. would rather have "defaults" be here...)
	
	vsoStorageLoad( loadStoredData );	--Load our data (asynchronous, so it takes a few frames)
	
	vsoOnBegin( "state_idle", function()
		vsoUseLounge( false, "drivingSeat" )
		--vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )	--Hm. If we have a interactive VSO AND a interactive static thing...
	end )
	
	vsoOnInteract( "state_idle", function( targetid )
	
		local anim = vsoAnimCurr( "bodyState" );
			
		if storage.belly < 50 then
		
			if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then
				
				local bits, bitscomplete, bitsname = vsoTargetHoldingItemMatch( "food", { config = { category="food" }, directory="/items/generic/meat/" } )
				if (bits > 0) and (bits == bitscomplete) then
					
					if storage.belly > 0 then	--If you are HOLDING MEAT and FRIENDLY DINO then attempt to be hand fed
			
						self.foodtargetid = nil;
						self.foodtargetname = bitsname;
						self.foodtargetfromhand = 1;
						self.victimhadsteak = 10;
						vsoNext( "state_gulp_item" )
						
					else	--Eat that mean player not feeding you enough!
						
						showEmote("emotesad");
						vsoCounterReset( "hungrywait" );
						self.victimhadsteak = 0;
						self.foodtargetname = nil;
						vsoNext( "state_player_eat" )
					end
					
				else
				
					if storage.belly > 20 then	--Not holding steak!
					
						vsoHasStatus( vsoGetTargetId( "food" ), "droolsoaked", function( result )	--Have we already licked the player?
							
							if result then
								
								if vsoChance( 50 ) then	--You just GOT licked...
								
									showEmote("emoteconfused");	
									
								else	--Eat player that has been licked! They asked for it.
									
									vsoCounterReset( "hungrywait" );
									self.victimhadsteak = 0;
									self.foodtargetname = nil;
									vsoNext( "state_player_eat" )
								end
							else
							
								showEmote("emotehappy");
								vsoAnim( "bodyState",  "lickbegin" );
							end
						end )
					
					else	--You havent fed me and I'm upset! I'll nom YOU
					
						showEmote("emotesad");
						vsoCounterReset( "hungrywait" );
						self.victimhadsteak = 0;
						self.foodtargetname = nil;
						vsoNext( "state_player_eat" )
					end
				end
				
			else
			
				chatterIdly();
			end
		else
		
			chatterIdly();
		end
		
	end )
	
	vsoOnEnd( "state_idle", function()
		vsoMakeInteractive( false )
		animator.setParticleEmitterActive( "burp", false )
		animator.setParticleEmitterActive("drips", false)
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_full", function()
	
		local bits, bitscomplete, bitsname = vsoTargetHoldingItemMatch( "food", { config = { category="food" }, directory="/items/generic/meat/" } )
		if (bits > 0) and (bits == bitscomplete) then
			self.victimhadsteak = 10;
			vsoAnim( "bodyState", "fullbig" );
		else
			if self.victimhadsteak > 0 then
				vsoAnim( "bodyState", "fullbig" );
			else
				vsoAnim( "bodyState", "full" );
			end
		end
		
		vsoUseLounge( true, "drivingSeat" )
		
		vsoVictimAnimVisible( "drivingSeat", false )
		vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
		
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatebelly" } );	--, "vsosoftdigest"
		
		vsoAnimSpeed( 1.0 );
		
		vsoCounterReset( "squirming" )
				
		vsoTimerSet( "gurgle", 0.5, 5 )	--For playing sounds
		
		vsoOnNPCInputOverride( "state_full", function( seatname, inputstruct ) 
			--Do nothing. We handle this elsewhere.
		end )
		
	end )
	
	---------------------------------------------------------------------------

	vsoOnBegin( "state_release", function()
	
		vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicateout" } );
	
		changeFeedStat( "toured", "people", 1 )
	
		vsoAnim( "bodyState", "pushout" )
		
		vsoVictimAnimVisible( "drivingSeat", true )
		vsoVictimAnimReplay( "drivingSeat", "pushout", "bodyState" )
		
		vsoSound("pushout");
	end )
	
	vsoOnEnd( "state_release", function()

		vsoUneat( "drivingSeat" )
		
		vsoApplyStatus( "food", "droolsoaked", 5.0 );	--Add status effect "droolsoaked"
		
		vsoSetTarget( "food", nil )
		vsoAnim( "bodyState", "idle" )
		vsoUseLounge( false, "drivingSeat" )
		
	end )
	
	---------------------------------------------------------------------------
	
	vsoOnBegin( "state_gulp_item", function()

		if self.foodtargetfromhand > 0 then
			vsoAnim( "bodyState", "itemeatfromhand" );
		else
			vsoAnim( "bodyState", "itemeat" );
		end
		self.foodtargetfromhand = 0;
		
	end )
	
	vsoOnEnd( "state_gulp_item", function()
		vsoMakeInteractive( true )
		vsoAnim( "bodyState", "idle" )
	end )
	---------------------------------------------------------------------------
	
	vsoOnBegin( "state_player_eat", function()
		
		vsoMakeInteractive( false )
		vsoAnim( "bodyState",  "playerbiteready"  )
		vsoSound( "biteready" );
	end )
	
	vsoOnEnd( "state_player_eat", function()
		
	end )
	
end

-------------------------------------------------------------------------------

function onEnd()
	
	vsoEffectWarpOut();
	
end

-------------------------------------------------------------------------------

function state_idle()
	
	local anim = vsoAnimCurr( "bodyState" );
	
	if storage.belly < 40 then
		if anim == "idlestand" or anim == "idle" or anim == "idlefat" then
			local licktimefactor = 4.0;
			if anim == "idlestand" then licktimefactor = 1.0 end
			if vsoTimerEvery( "licktimer", 1.0*licktimefactor, 15.0*licktimefactor ) then
				vsoAnitagAnim( vsoVal( "ani_head_liplick" ) )
			end
		end
	end

	if vsoAnimEnd( "bodyState" ) then

		storage.belly = storage.belly - vsoTimeDelta( "belly" )*(20.0/1200.0)	--Do a DELTA TIME subtraction for hunger. 20 is a full tummy (20 minutes. 50 is fat. 100 is max? Hm.
		if storage.belly < 0 then
			storage.belly = 0;
		end
		vsoStorageSaveKey( "belly" );
		
		if anim == "lickbegin" then
		
			if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then
				vsoApplyStatus( "food", "droolsoaked", 5.0 );
				vsoSound( "slurp" );
			end
		
			vsoAnim( "bodyState",  "lickend"  )
		elseif anim == "lickend" then

			vsoAnim( "bodyState",  "idle"  )
		else

			if storage.belly <= 0 then
				vsoAnitagAnim( vsoVal( "ani_head_angry" ) )
			elseif storage.belly < 20 then
				vsoAnitagAnim( vsoVal( "ani_head_dissapoint" ) )
			else
				vsoAnitagAnim( vsoVal( "ani_head_normal" ) )
			end
		
			vsoAnimSpeed( 1.0 );
			self.victimhadsteak = 1.0;
			
			if anim == "idleburp" then
				animator.setParticleEmitterActive( "burp", false )
			end
			if anim == "idlestanddrool" then
				animator.setParticleEmitterActive("drips", false)
			end
			
			if storage.burpsloaded > 0 and vsoChance( 20 ) then
			
				storage.burpsloaded = storage.burpsloaded - 1;
				vsoStorageSave();
				
				vsoAnim( "bodyState",  "idleburp"  )
				vsoSound( "burp" );
				
			else
			
				if storage.belly > 50 then
				
					vsoAnim( "bodyState",  "idlefat"  )
					vsoAnitagAnim( vsoVal( "ani_head_happy" ) )
					
					if vsoTimerEvery( "loveemit", 10, 120 ) then
						vsoSound( "please" );
						showEmote("love");
						vsoTimerReset( "loveemit" )
					end
					
				else
				
					vsoAnim( "bodyState",  "idle"  )
					
					local gotfood = false;
					
					if storage.belly <= 0 then
					
						if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then
				
							vsoAnimSpeed( 3.0 )
							vsoCounterReset( "hungrywait" );
							self.victimhadsteak = 0;
							self.foodtargetname = nil;
							vsoNext( "state_player_eat" )
							gotfood = true;
						end
					end
					
					if gotfood then
					
					else
						
						local itemId,itemname = vsoCheckItemDrop( 1.8125, -1.875, 1.5, nil );
						if itemId then
						
							local bits, bitscomplete = vsoItemMatch( itemname, { config = { category="food" }, directory="/items/generic/meat/" } );
						
							if (bits > 0) and (bits == bitscomplete) then	--INTENDING TO FEED ME LIKE AN ANIMAL +1
								
								changeFeedStat( "offered", "floormeats", 1 )

								self.foodtargetid = itemId;
								self.foodtargetname = itemname;
								self.foodtargetfromhand = 0;
								
								gotfood = true;
								vsoNext( "state_gulp_item" )
							
							elseif (bits > 0) then --WRONG KIND OF FOOD -0
								
								vsoSay( "Rrgh!.\n(Want meat! Not that!)" );	--want == "..itemname.."
							else	--I DONT LIKE THAT ITEM -1
								
								vsoSay( "Rgrgrr.\n(Gross, I dont want that.)" );	-- want == "..itemname.."
							end
						
						end
					end
					
					if gotfood then
					
					else
						
						if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then	--Can we see if the player is HOLDING meat? (eat them)
						
							local bits, bitscomplete, bitsname = vsoTargetHoldingItemMatch( "food", { config = { category="food" }, directory="/items/generic/meat/" } )
							if (bits > 0) and (bits == bitscomplete) then
				
								
								if vsoCounter( "hungrywait" ) then	--fires when counter STARTS from zero (so only once per)
									
									changeFeedStat( "offered", "handmeats", 1 )
									vsoSound( "purr" );
									vsoSay( "Rrrr?\n(Oooo you have "..bitsname.."!)" );
								end
								
								vsoAnim( "bodyState",  "idlestand"  )
				
								
								if vsoCounterChance( "hungrywait", 5, 20 ) then	--Fired after 5, but before or equal to 20 with linearly increasing frequency. --MAKING ME WAIT WAY TOO LONG?! -21
									
									changeFeedStat( "teased", "handmeats", 1 )
									gotfood = true;
									
									vsoCounterReset( "hungrywait" );
									
									self.victimhadsteak = 10.0;
									
									self.foodtargetname = bitsname;
									
									vsoNext( "state_player_eat" )
									
								elseif vsoCounterPercent( "hungrywait", 5, 20 ) > 0 then	--MAKING ME WAIT TOO LONG?! -6
								
									vsoAnim( "bodyState",  "upsetstand"  )
								else
									if vsoChance( 50 ) then	--How hungry ARE we? Hm.
									
										animator.setParticleEmitterActive("drips", true)
										vsoAnim( "bodyState",  "idlestanddrool" )
									
									end
								end
							else
							
								if vsoChance( 1 ) then	--If nothing is happening and someone is around...
								
									chatterIdly();
									
								end
							end
						end
					end
				end
			end
		end
	else
		
		--Well? This is a SPECIAL CASE for "soft digest"
		local eatid = vsoHasEatenId("drivingSeat");
		if eatid ~= nil then
			local movetype,movedir = vso4DirectionInput( "drivingSeat" );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
			if movetype == -1 then	--Is it a NPC we just ate?
			
				--NPC motion should be a bit more reasonable; since we are overriding them...
			
				if vsoChance( 1 ) then--3 ) then	--They dont like it? Hm.
					movetype = 1;
					movedir = vsoPick( {"F", "B", "U", "D"} );
				end
			end
			if movetype > 0 and movedir ~= nil then
				vsoUneat( "drivingSeat" )
				vsoUseLounge( false, "drivingSeat" )
				vsoSetTarget( "food", nil )
			end
		end

		if anim == "idleburp" then
		
			local vayu = animator.animationStateProperty( "bodyState", "index" )
			if vayu >= 8 then
				animator.setParticleEmitterActive( "burp", false )
			else
				animator.setParticleEmitterActive( "burp", true )
			end
		elseif anim == "full" or anim == "full2" or anim == "idlefat" then
			
			if storage.belly > 50 then
				if vsoTimerEvery( "loveemit", 10, 120 ) then
					vsoSound( "please" );
					showEmote("love");
					vsoTimerReset( "loveemit" )
				end
			end
		end
	end
end

-------------------------------------------------------------------------------

function state_full()

	if vsoTimer( "gurgle" ) then	--play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
		vsoTimerSet( "gurgle", 1.0, 8.0 )
		vsoSound( "digest" )
	end

	local anim = vsoAnimCurr( "bodyState" );
	
	local nextanim = anim
	local needsreplay = vsoAnimEnd( "bodyState" );
	if needsreplay then
		
		vsoAnimSpeed( 1.0 );
		if anim == "full" or anim == "full2" then
			if vsoChance( 50 ) then
				nextanim = "full2"
			else
				nextanim = "full"
			end
			
			if vsoPill("digest") then --Did we get a pill to change our behaviour? Hm...
				if true then --storage.belly <= 0.0 then	--Doesnt start digesting until we are STARVING. Hm...
					vsoResourceAddPercent( vsoGetTargetId("food"), "health", -3 * vsoPillValue( "digest" ), function(stillalive)
						if not stillalive then
							
							vsoApplyStatus( "food", "vsokillnpcsit", 1.0 )
											
							vsoUneat( "drivingSeat" )
							vsoUseLounge( false, "drivingSeat" )
							vsoSetTarget( "food", nil )
							vsoAnim( "bodyState", "idlefat" )
							vsoNext( "state_idle" )
							
							changeBellyStat( (100 - storage.belly) );
						else
							--
						end
					end );	--Change resource?
				end
			elseif vsoPill("softdigest") then
			
				vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", -3 * vsoPillValue( "softdigest" ), 0, function(stillalive)
					if not stillalive then
						--Well this is odd. we switch to full but don't release them? Hm.
						vsoVictimAnimClearReady( "drivingSeat", { 0, 0 }, false );	--Aggressive?
						
						changeBellyStat( (100 - storage.belly) );
						
						anim = "idlefat"; 
						nextanim = "idlefat";
						vsoNext( "state_idle" )
					end
				end )
				
			elseif vsoPill("heal") then
				--Push prey out once fully healed... (maybe a bit annoying?)
				vsoResourceAddPercentThreshold( vsoGetTargetId("food"), "health", 1 * vsoPillValue( "heal" ), 100, function( inrange )
					if not inrange then
						vsoResourceAddPercent( vsoGetTargetId("food"), "health", 1 );	--Fully heal
						vsoNext( "state_release" )	--release
						
						vsoSound( "please" );
						showEmote("love");
						vsoTimerReset( "loveemit" )
					end
				end )
			end
			
		elseif anim == "fullbig" then
		
			self.victimhadsteak = self.victimhadsteak - 1;
			if self.victimhadsteak < 0 then
				self.victimhadsteak = 0;
				nextanim =  "full"
				
				if self.foodtargetname ~= nil  then
					vsoTakeItemFromTarget( "food", self.foodtargetname, 1 );
					self.foodtargetname = nil
				end
				
			else
			
				if vsoChance( 10 ) then
					nextanim =  "toonbelly"
				else
					nextanim =  "fullbig"
				end
			end
		elseif anim == "toonbelly" then
		
			nextanim =  "onbelly" 
		elseif anim == "fromonbelly" then
		
			nextanim =  "fullbig" 
		elseif anim == "onbelly" then
		
			if vsoChance( 20 ) then
				nextanim =  "fromonbelly"
			else
				nextanim =  "onbelly"
			end
		else
			anim = "full"	--hack! not ok!
			nextanim = "full2";
		end
	end
	
	local movetype,movedir = vso4DirectionInput( "drivingSeat" );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
	if movetype == -1 then	--Is it a NPC we just ate?
		if vsoChance( 1 ) then--3 ) then	--They dont like it? Hm.
			movetype = 1;
			movedir = vsoPick( {"F", "B", "U", "D"} );
		end
	end
	
	if anim == "full" or anim == "full2" then
	
		local emitlove = vsoTimerEvery( "loveemit", 10, 120 )
	
		local squirming = 0;
		if movedir == 'B' then
			squirming = 1; 
			nextanim = "squirmB"
			if movetype == 2 then nextanim = "squirmrubB" squirming = 2; end
		elseif movedir == 'F' then
			squirming = 1; 
			nextanim = "squirmF"
			if movetype == 2 then nextanim = "squirmrubF" squirming = 2; end
		elseif movedir == 'D' then
			squirming = 1; 
			nextanim = "squirmD"
			if movetype == 2 then nextanim = "squirmrubD" squirming = 2; end
		elseif movedir == 'U' then
			squirming = 1; 
			nextanim = "squirmU"
			if movetype == 2 then nextanim = "squirmrubU" squirming = 2; end
		else
			local what = vsoGetInputRaw( "drivingSeat" )
			if what ~= nil then
				if what.fastJ > 0 then
					squirming = 1; nextanim = "squirmU";
				elseif what.fastA > 0 or what.fastB > 0 then
					squirming = 1; 
					nextanim = vsoPick( { "squirmB", "squirmF", "squirmD", "squirmU" } )
				elseif what.slowJ > 0 then
					squirming = 1; nextanim = "squirmrubU";
				elseif what.slowA > 0 or what.slowB > 0 then
					squirming = 2; 
					nextanim = vsoPick( { "squirmrubB", "squirmrubF", "squirmrubD", "squirmrubU" } )
				end
			end
		end
	
		if squirming > 0 then
			if squirming == 2 then
				emitlove = true
			else
				vsoSound( "struggle" );
				vsoTimerReset( "loveemit" )
				if vsoCounterChance( "squirming", 5, 15 ) then
					vsoNext( "state_release" )	--release
				else
					vsoCounter( "squirming" )
				end		
			end
		else
			vsoCounterSub( "squirming", self.vsodt/2.0 );	--just in case!
		end
		
		if emitlove then
			vsoSound( "please" );
			showEmote("love");
			vsoTimerReset( "loveemit" )
		end
	end
	if nextanim ~= anim or needsreplay then
		vsoAnim( "bodyState",  nextanim )
	end
	
	local eatid = vsoHasEatenId("drivingSeat");
	if eatid ~= nil then
		
	end
end

-------------------------------------------------------------------------------

function state_release()

	local anim = vsoAnimCurr( "bodyState" );
	
	if vsoAnimEnd( "bodyState" ) then
	
		if anim == "pushout" then
		
			vsoTimerSet( "delay", 0.25, 0.25 )	--For playing sounds?
			
			vsoAnim( "bodyState",  "pushoutend"  )
		else
		
			vsoNext( "state_idle" )	--release
		end
		
	end
	
	if anim == "pushoutend" then
	
		if vsoVictimAnimClearReady( "drivingSeat", { -3.5, 0 }, true ) then
			vsoNext( "state_idle" )	--release
		end
	end
end

function state_gulp_item()

	local anim = vsoAnimCurr( "bodyState" );
	if vsoAnimEnd( "bodyState" ) then
	
		if anim == "itemeat" then
		
			if vsoEatItemDrop( self.foodtargetid ) then	--FED LIKE AN ANIMAL +3
			
				changeBellyStat( vsoGetItemParameter( self.foodtargetname, "foodValue", 5 ) )	--Get item foodValue ? Get item config value? Default to 5
						
				
				changeFeedStat( "eaten", "floormeats", 1 )
				vsoAnim( "bodyState", "itemtochew" );
				vsoSound( "chomp" );
			else	--TEASING WITH FOOD ON FLOOR = -5
				
				changeFeedStat( "missed", "floormeats", 1 )
				vsoAnim( "bodyState", "itemeatmiss" );
			end
			
			self.foodtargetid = nil;
				
		elseif anim == "itemeatfromhand" then
		
			if self.foodtargetname ~= nil  then
			
				if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then	--Must be proximous
				
					vsoTakeItemFromTarget( "food", self.foodtargetname, 1, function( result )
					
						if result then	--FEEDING MY BY HAND <3 + 10
						
							changeBellyStat( vsoGetItemParameter( self.foodtargetname, "foodValue", 5 ) )	--Get item foodValue ? Get item config value? Default to 5
							
							
							changeFeedStat( "eaten", "handmeats", 1 )
							vsoAnim( "bodyState", "itemfromhandtochew" );
							vsoSound( "chomp" );
						else	--NO FOOD TO GIVE?! THROWING IT AWAY?!? -20
							
							changeFeedStat( "missed", "handmeats", 1 )
							vsoAnim( "bodyState", "itemfromhandmiss" );
						end
					end );
				else	--TEASING WITH FOOD = -10
					
					changeFeedStat( "teased", "handmeats", 1 )
					vsoAnim( "bodyState", "itemfromhandmiss" );
				end
			
			else
				--What happened? no food???
				
			end
			self.foodtargetid = nil;
			
		elseif anim == "itemfromhandtochew" then
			vsoAnim( "bodyState", "itemchew" );
			vsoSound( "chew" );
		
		elseif anim == "itemtochew" then
			vsoAnim( "bodyState", "itemchew" );
			vsoSound( "chew" );
				
		elseif anim == "itemchew" then
			if vsoChance( 20 ) then 
				vsoAnim( "bodyState", "itemgulp" );
				vsoSound( "gulp" );
			else
				vsoAnim( "bodyState", "itemchew" );
				vsoSound( "chew" );
			end
			
		elseif anim == "itemgulp" then
		
			vsoAnim( "bodyState",  "idle"  )
			vsoNext( "state_idle" )
			vsoSay( "Mrawr!\n(Yummy "..self.foodtargetname.."!)" );
				
			vsoCounterReset( "hungrywait" );
							
			storage.burpsloaded = storage.burpsloaded + 1;
			vsoStorageSave();
			
		else
		
			vsoAnim( "bodyState",  "idle"  )
			vsoNext( "state_idle" )
		end
	end
	
end

function state_player_eat()

	local anim = vsoAnimCurr( "bodyState" );
	
	if anim == "playereat" then	--Sometimes, you miss so handle that. vsoEat may FAIL if you put a lot of VSO's next to eachother so be kind to players/npcs...
		if vsoTargetIsEaten( "food", 30 ) then	--Note I've seen this take 10 steps so 30 is a reasonable idea. 1/4 second is default (15)
			--good!
		else
			--Not good!
			--sb.logInfo( "missed food??" );
			vsoUneat( "drivingSeat" );
			vsoSound( "chomp" );
			vsoAnim( "bodyState", "playerbitemiss" );
			vsoNext( "state_idle" )
			return
		end
	end

	if vsoAnimEnd( "bodyState" ) then
	
		if anim == "playerbiteready" then
		
			vsoAnimSpeed( 1.0 )
			
			if vsoUpdateTarget( "food", 1, -2, 3, 1 ) then
			
				vsoEat( vsoGetTargetId( "food" ), "drivingSeat" )
				
				vsoCounterReset( "playervictimeat" );
				
				vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatemaw" } );--, "vsosoftdigest""voreheal", "nude" } );	--Hey, you can change this anytime! nice.
				
				vsoAnimSpeed( 1.0 );
				vsoSound("eatchomp");
				
				vsoTimerSet( "gurgle", 0.5, 5 )	--For playing sounds
				
				vsoAnim( "bodyState", "playereat" );
				vsoVictimAnimVisible( "drivingSeat", true )
				vsoVictimAnimReplay( "drivingSeat", "playereat", "bodyState")
			else
				vsoSound( "chomp" );
				vsoAnim( "bodyState", "playerbitemiss" );
			end
			
		elseif anim == "playereat" then
		
			vsoVictimAnimSetStatus( "drivingSeat", { "vsoindicatebelly" } );--, "vsosoftdigest""voreheal", "nude" } );	--Hey, you can change this anytime! nice.
			
			vsoNext( "state_full" )
		else
			
			vsoCounterSet( "hungrywait", 5 );	--still mad
							
			vsoAnim( "bodyState", "idle" )
			vsoNext( "state_idle" )
		end
	elseif anim == "playereat" then
		
		local atime = vsoVictimAnimTime( "drivingSeat" )
		if vsoCounterValue( "playervictimeat" ) == 0 then
			if atime > 1.5 then
				vsoSound("swallow");
				vsoCounter( "playervictimeat" );
			end
		end
	end
end