--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo

require("/scripts/vore/vsosimple.lua")

--[[ 

Use this to clear problem vehicles:		/entityeval vehicle.destroy()

dinosuit plan

Without rider

	Does nothing?
	
With rider

	Animation List:
		idle, walk, run
		crouchdown, crouch, crouchup
		jumpup, inair, falling
		
		fastbite
		biteready
		bitemiss
		

	Can walk left/right
		idle, walk
	Can jump (on release?)
		jumpup, inair, falling
	Can hold down and jump to fall through platforms
	
	Double tap to start running? (hold to run)
		run
	If you are running, you can hold jump to pounce?
		crouch
	Attacks vary depending on what you are doing... Hm.
		bite (tap A)
		vorebite (hold A)
		holdB -> pie menu
			4/8 direction pie menu to select action (in case we have more things?)
			Using mouse alt-fire makes the pie around the mouse cursor?
			Versus keyboard/joystick circle around the vehicle itself?
	
	If you swallow someone completely (arent attacked during swallow)
		They can struggle in your belly while you run around
		You have to stop and choose to digest them / play with prey?
		You can eject them in this mode
		Also the holdB -> pie menu in this mode can be complicated!
		But is essential for the predator.
			(try and use local animator, so that ONLY the controlling player can see it? is that possible?)
			Open question about what the predator sees vs. what the victim sees...
				(dialog? Hm...)

]]--

-------------------------------------------------------------------------------

function onForcedReset( )	--helper function. If a victim warps, vanishes, dies, force escapes, this is called to reset me. (something went wrong) 

	vsoAnimSpeed( 1.0 );
	vsoVictimAnimVisible( "drivingSeat", false )
	vsoUseLounge( false, "drivingSeat" )
	vsoVictimAnimVisible( "victimSeat", true )
	vsoUseLounge( false, "victimSeat" )
	vsoUseSolid( false )
		
	vsoNext( "state_normal" )
	vsoAnim( "bodyState", "idle" )
	
	vsoMakeInteractive( true )
end

function onStore()
	--If you return true, you MUST destroy the vehicle when stored.
	--Usually you play a warpout animation for this, THEN vsoForceDeath();
	vsoEffectWarpOut();
	vsoForceDeath();
	return true;--self.driver.id == nil
end

function onBegin()	--This sets up the VSO ONCE.

	self.fall_through_platforms = false;
	self.anim = "idle"
	self.nextanims = { "idle" }
	self.changeanims = false;

	onForcedReset();	--Do a forced reset once.
	
	vsoOnBegin( "state_normal", function()
	
		vsoUseLounge( false, "drivingSeat" )
		vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )	--Hm. If we have a interactive VSO AND a interactive static thing...
		
	end )
	
	vsoOnInteract( "state_normal", function( targetid )
	
		local eatid = vsoHasEatenId("drivingSeat");
		if eatid then
			--ignore, already have a driver.
			
			--Other things someone else can do of course!
			
		else
			--Hm... must match "owner" to "safely" get eaten?
			vsoEat( targetid, "drivingSeat" )
			--"invis"
			vsoMakeInteractive( false ); 
		end
		
		
	end )
end

-------------------------------------------------------------------------------

function onEnd()
	
	--vsoEffectWarpOut();
	
end

function state_normal()
	
	local eatid = vsoHasEatenId("drivingSeat");
	
    if (eatid ~= nil) then
      vehicle.setDamageTeam( world.entityDamageTeam(eatid) )
    else
      vehicle.setDamageTeam( {type = "passive"} )
    end
	
	self.anim = vsoAnimCurr( "bodyState" );
	self.animended = vsoAnimEnd( "bodyState" );
	
	local eatid = vsoHasEatenId("drivingSeat");
	local new_fall_through_platforms = self.fall_through_platforms;
	
	self.inputs = nil;
	
    if (eatid ~= nil) then
		
		self.inputs = vsoGetInput( "drivingSeat" )
	end
		
    --move()
    --updateDamage()
    --updateDriveEffects(healthFactor, driverThisFrame)
    --updatePassengers(healthFactor)
	
	vsoUpdateTarget( "food", 1, -2, 3, 1 );
	
	state_normal_body();
	
    state_normal_controls()
	
	if self.changeanims then
		self.changeanims = false;
		if #self.nextanims > 0 then
			self.anim = self.nextanims[1];
			if #self.nextanims > 1 then
				table.remove( self.nextanims, 1 );
			end
		end
		vsoAnimReplay( "bodyState", self.anim )
	else
		if self.animended then
			if #self.nextanims > 0 then
				self.anim = self.nextanims[1];
				if #self.nextanims > 1 then
					table.remove( self.nextanims, 1 );
				end
			end
		end
		vsoAnim( "bodyState", self.anim )
	end
end

function state_normal_body()

	if self.anim == "playerbiteready" then	--Sometimes, you miss so handle that. vsoEat may FAIL if you put a lot of VSO's next to eachother so be kind to players/npcs...
		
		if vsoGetTargetId( "food" ) then--#vsoUpdateTarget( "food", 1, -2, 3, 1 ) then
		
			if self.animended then
			
				vsoUseLounge( true, "victimSeat" )
				vsoEat( vsoGetTargetId( "food" ), "victimSeat" )
				
				vsoSound("eatchomp");
				
				vsoTimerSet( "gurgle", 0.5, 5 )	--For playing sounds
				
				--vsoVictimAnimVisible( "victimSeat", true )
				vsoAnim( "bodyState", "playereat" );
				vsoVictimAnimReplay( "victimSeat", "playereat", "bodyState" )
				
				self.nextanims = { "playereat", "full" }
				self.changeanims = true;
			end
		end
	elseif self.anim == "playereat" then
		
		vsoCounterReset( "squirming" )
		
		--???
	
	elseif self.anim == "playerbitemiss" then
	
		--vsoSound( "chomp" );
	elseif self.anim == "full" or self.anim == "full2" then
	
		vsoVictimAnimVisible( "victimSeat", false )
		
		if vsoTimer( "gurgle" ) then	--play gurgle sounds <= "Play sound from list [soundlist] every [ 1 to 8 seconds ]"
			vsoTimerSet( "gurgle", 1.0, 8.0 )
			vsoSound( "digest" )
		end
		
		local forcerelease = false;
		local nextanim = nil;
			
		if self.inputs.B > 1 then
			forcerelease = true;
		else
		
			local movetype,movedir = vso4DirectionInput( "victimSeat" );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
			if movetype == -1 then	--Is it a NPC we just ate?
				if vsoChance( 1 ) then--3 ) then	--They dont like it? Hm. Depends? sinusoid this?
					movetype = 1;
					movedir = vsoPick( {"F", "B", "U", "D"} );
				end
			end
			
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
				local what = vsoGetInputRaw( "victimSeat" )
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
					vsoSound( "please" );--emitlove = true
				else
					vsoSound( "struggle" );
					vsoTimerReset( "loveemit" )
					if vsoCounterChance( "squirming", 5, 15 ) then
						forcerelease = true;-- "state_release" )	--release
					else
						vsoCounter( "squirming" )
					end		
				end
			else
				vsoCounterSub( "squirming", self.vsodt/2.0 );	--just in case!
			end
		end
		
		if forcerelease then
			
			self.nextanims = { "pushout", "pushoutend" }
			self.changeanims = true;
			
			vsoVictimAnimVisible( "victimSeat", true )
			vsoVictimAnimReplay( "victimSeat", "pushout", "bodyState" )
				
			vsoSound("pushout");
		elseif nextanim then
			if self.inputs.A > 0.0 then
				self.nextanims = { nextanim, "toonbelly", "onbelly" }
			else
				if vsoChance( 25 ) then
					self.nextanims = { nextanim, "full2" }
				else
					self.nextanims = { nextanim, "full" }
				end
			end
			self.changeanims = true;
		else
		
			if self.inputs.A > 0.0 then
				self.nextanims = { "toonbelly", "onbelly" }
			else
				if self.animended then
					if vsoChance( 25 ) then
						self.nextanims = { "full2" }
					else
						self.nextanims = { "full" }
					end
					self.changeanims = true;
				end
			end
			
		end
		
	elseif self.anim == "onbelly" then
	
		if self.inputs.A > 0.0 then
			self.nextanims = { "onbelly" }
		else
			self.nextanims = { "fromonbelly", "full" }
		end
		
	elseif self.anim == "pushoutend" then
	
		if vsoVictimAnimClearReady( "victimSeat", { -3.5, 0 }, true ) then
			
			vsoUneat( "victimSeat" )
			vsoUseLounge( false, "victimSeat" )
		end
		
		if self.animended then
			
			vsoUneat( "victimSeat" )
			vsoUseLounge( false, "victimSeat" )
			self.nextanims = { "idle" }
			self.changeanims = true;
		end
	end

end

function state_normal_controls()

	local new_fall_through_platforms = self.fall_through_platforms;
	
    if (self.inputs ~= nil) then
		
		local inputs = self.inputs
		
		--inputs.L	left
		--inputs.R	right
		--inputs.U	up
		--inputs.D	down
		
		--inputs.J	jump
		
		--inputs.A	a (primary attack)
		--inputs.B	b (secondary attack)

		--inputs.E--Tap it a lot to "quit" vehicle... huh...
		
		if inputs.E > 0 then
		
			--Attempt to "interact" through player passthrough?
			--IE pass the position of the mouse and send a player interact?
			--Opening doors eh?
		
		end
		
		local canmove = (self.anim == "idle");
		
		if canmove then
			
			if inputs.A > 0 or inputs.B > 0 then
			
				--Huh!
				if inputs.A > 0 and inputs.B == 0 then
				
					self.nextanims = { "itemeat", "itemeatmiss", "idle" }
					self.changeanims = true;
				elseif inputs.B > 0 and inputs.A == 0 then
				
					self.nextanims = { "playerbiteready", "playerbitemiss", "idle" }
					self.changeanims = true;
					vsoSound( "biteready" );
				end
			
			else
			
				new_fall_through_platforms = false;
			
				local dx = inputs.R - inputs.L;
				if dx > 0 then dx = 1; vsoFaceDirection( dx ); elseif dx < 0 then dx = -1; vsoFaceDirection( dx ); end
				
				--double tap to "run" ?
				
				mcontroller.approachXVelocity( 12*dx, 200 );--self.targetHorizontalVelocity, self.horizontalControlForce)
				
				if mcontroller.onGround() then
				
					if inputs.D > 0 and inputs.J > 0 then
					
						new_fall_through_platforms = true;	--fall through platforms? "ignorePlatformCollision"
						
					elseif inputs.J > 0 then
					
						mcontroller.setYVelocity( 34 )
					end
					
				end
				
				if inputs.D > 0 and self.fall_through_platforms then
				
					new_fall_through_platforms = true;	--fall through platforms? "ignorePlatformCollision"
					
				end
			
			end
		end
		
	else
	
		--Nothing? Act like a normal SPOV thing? Huh...
	
	end

	if self.fall_through_platforms ~= new_fall_through_platforms then
		self.fall_through_platforms = new_fall_through_platforms
		vsoMotionParam( { ignorePlatformCollision = self.fall_through_platforms } );
	end
end
