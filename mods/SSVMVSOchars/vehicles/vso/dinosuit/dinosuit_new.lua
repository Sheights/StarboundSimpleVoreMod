--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo

require("/scripts/vore/vsosimple.lua")
require("/scripts/vsoplayersim.lua")	--for simulating player type actions
require "/tech/doubletap.lua"

--[[

Use this to clear problem vehicles:		/entityeval vehicle.destroy()

Create me in game: /spawnitem vorevsodinosuit_newitem

dinosuit plan

PHYSICS ISSUES:
	10 x 6 size image (offset by 16 px from left...)
		center is 6, 0 (+- 4 cells from center, but we had to add 2 for the tail
		animation offset is: [-6.0, -3.0] so the center is true
	,"duck":{ "collisionPoly" : [ [-2, 1], [-2, -3], [2, -3], [2, 1] ] }
	,"stand":{ "collisionPoly" : [ [-2, 2.5], [-2, -3], [2, -3], [2, 2.5] ] }
	Lekra:
		DONE 1) vsoGetBoundsAhead: yspace actually shrinks the box if > 0 and grows if < 0
		DONE 2) vsoToggleDoorsAhead: world.rectTileCollision(bounds, {"Dynamic"}) returns false with opened doors (you can thank Starbound)
		DONE 3) when one enters your raptor, it calls vsoToggleDoorsAhead A LOT (4-8 times in a row when I normally tap to enter it)
		DONE 4) I think you wanted your pie to start vertically then count CW, but now it starts horizontally and counts CCW (no comment on da basic drawing representing your pie, just need to rotate a little so 0 and 4 are horizontally aligned >..>)
	Sheights:
		DONE rage effect, kickback effect can disable player? Hmmm... No, we can't do any better than stopping everything but active items (without a VSO involved)
	DONE Can't seem to "walk" properly up/down blocks like a NPC can...
	DONE 	Apparently there is more code to fix for this. (direct block checks? Hm...) Possibly slightly adjusting the bounding box angle?
	DONE enable jump back in for owner and owner escape failout
	DONE E key is now seamless in activation frequency (reliable button press for E)
	DONE interact with NPC's seems to work, position is a bit flakey
	
	Holding pie does not FOLLOW your position please fix that (screen position? Hm... because the player can aim, how do we screen pos...)
	Holding pie is on wrong layer (need UI for pie?)
	Can we shoot/eat monsters? Stomp on them? Can we run yet and bite while running??
		More importantly, can we eat monsters without messing with their lua scripts?
		IE, status-y things are OK for them? Still hard to get access to their state.


Without rider

	Does nothing? Probably should auto-return to inventory... or be a "ghost" stand...
	
	Or, should the second you spawn it, it "consumes" you and you become it instantly? (no waiting for rider?)

With (player character) rider

	Animation List:
		idle, walk, run
		duckdown, duck, duckup, duckcrawl
		jumpup, inair, jumpdown, falling, landing

		bite, bitemiss

		damaged
		death


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

function changeAnim( v )
	if #self.nextanims > 0 then
		if self.nextanims[1] ~= v then
			self.changeanims = true
		end
	end
	self.nextanims = { v };
end

function changeAnims( vl )
	if #vl > 0 then
		if #self.nextanims ~= #vl[1] then
			if self.nextanims[1] ~= vl[1] then
				self.changeanims = true
			end
		end
		self.nextanims = vl;
	end
end

function pie_index_calculate( dx, dy, pie_sections )

	--8 pie actions each? Hm... multiple sub menus possible with a pie action changing the pie menu...
	--Basically, a pie menu is icons with alpha in a ring of 8 (always) around the mouse position...
	--starbound DOESNT have atan2???

	local piedist = math.sqrt( dx*dx + dy*dy );

	local theta = math.acos( dx / piedist );
	if dy < 0 then
		theta = -theta;
	end
	if theta < 0 then theta = theta + 2.0 * math.pi; end

	local pieindex = math.floor( 0.5 + pie_sections * ( theta/( 2.0 * math.pi ) ) ) % pie_sections;
	if pieindex < 0 then pieindex = pieindex + pie_sections end
	pieindex = math.floor( pieindex );

	return pieindex
end

function get_squirming_data( targetseat )

	local movetype,movedir = vso4DirectionInput( targetseat );	--movetype = 2 for please, 1 for fight/punch? movedir = "U" up "D" down "F" forward "B" back "J" jump
	if movetype == -1 then	--Is it a NPC we just ate?
		if vsoChance( 1 ) then--3 ) then	--They dont like it? Hm. Depends? sinusoid this?
			movetype = 1;
			movedir = vsoPick( {"F", "B", "U", "D"} );
		end
	end

	local nextanim = nil;
	local squirming = 0;
	if movedir == 'B' then
		squirming = 1;
		nextanim = "B"
		if movetype == 2 then nextanim = "rubB" squirming = 2; end
	elseif movedir == 'F' then
		squirming = 1;
		nextanim = "F"
		if movetype == 2 then nextanim = "rubF" squirming = 2; end
	elseif movedir == 'D' then
		squirming = 1;
		nextanim = "D"
		if movetype == 2 then nextanim = "rubD" squirming = 2; end
	elseif movedir == 'U' then
		squirming = 1;
		nextanim = "U"
		if movetype == 2 then nextanim = "rubU" squirming = 2; end
	else
		local what = vsoGetInputRaw( targetseat )
		if what ~= nil then
			if what.fastJ > 0 then
				squirming = 1; nextanim = "U";
			elseif what.fastA > 0 or what.fastB > 0 then
				squirming = 1;
				nextanim = vsoPick( { "B", "F", "D", "U" } )
			elseif what.slowJ > 0 then
				squirming = 1; nextanim = "rubU";
			elseif what.slowA > 0 or what.slowB > 0 then
				squirming = 2;
				nextanim = vsoPick( { "rubB", "rubF", "rubD", "rubU" } )
			end
		end
	end

	if squirming > 0 then
		if squirming == 2 then
			--vsoSound( "please" );--emitlove = true
		else
			--vsoSound( "struggle" );
			--vsoTimerReset( "loveemit" )
			if vsoCounterChance( "squirming", 5, 15 ) then
				forcerelease = true;-- "state_release" )	--release
			else
				vsoCounter( "squirming" )
			end
		end
	else
		vsoCounterSub( "squirming", self.vsodt/2.0 );	--just in case!
	end

  -- return { nextanim, squirming, forcerelease }
	return { nil, 0, false }
end

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
	self.xspeed = 12;	--changes depending on what you are doing. 24 is a GOOD run
	self.xvelocity = 0;
	self.xvelocityforce = 200;	--acceleration speed
	self.yjumpvelocity = 35;	--Should change depending on your jump holding? Hm...
	self.duckspeedfactor = 0.8;
	self.runspeedfactor = 2.0;
	self.running = false;
	self.lastcollisionpoly = nil;
	self.lastcollisionpolyname = nil;
	self.previous_onground = true;
	self.lastkeeponground = false;
	
	self.jumpacceldecay = 0.0;--new jump system
	self.jumpacceldecayfactor = 5  --1/5th of a second
	self.jumpacceldecayvelocity = 20;--24; sqrt(24) ~5
	self.jumpacceldecayvelocityprev = 0;
	
	self.doubleTapInput = false;
	self.doubleTap = DoubleTap:new({"left", "right"}, 0.25, function(dashKey)
		self.doubleTapInput = true;--Signal we WANT to double tap...
    end)

	--Easy color replace if you do it right...
	local allcolors = vsoVal( "colorOptions" );
	--sb.logInfo( tostring( allcolors ) );

	local coli = 1 + ( (math.floor( math.random()*9999 )) % (#allcolors) )	--because lua. Make a new color map. ( 12%12 == 0.
	local colorReplaceMap = allcolors[ coli ];
	self.firstdirectives = vsoMakeColorReplaceDirectiveString( colorReplaceMap )
	self.bellydirectives = "multiply=00000000;"..self.firstdirectives
	animator.setGlobalTag( "directives", "?"..self.firstdirectives )
	--animator.setGlobalTag( "bellydirectives", "?multiply=00000000" );--self.bellydirectives )
	animator.setPartTag( "belly", "bellydirectives", "?"..self.bellydirectives )

	self._message_args_default = jarray();
	jresize( self._message_args_default, 10 );

	onForcedReset();	--Do a forced reset once.

	if self.vsoSpawnVehicleOwnerEntityId ~= nil then

		--mcontroller.setPosition( world.entityPosition( self.vsoSpawnVehicleOwnerEntityId ) );

		vsoEat( self.vsoSpawnVehicleOwnerEntityId, "drivingSeat" )

		--Should DEFINITELY have a animation for this... not a problem.
	end

	vsoOnBegin( "state_normal", function()

		vsoUseLounge( false, "drivingSeat" )
		vsoAnim( "bodyState", "idle" )
		vsoMakeInteractive( true )	--Hm. If we have a interactive VSO AND a interactive static thing...

	end )

	vsoOnInteract( "state_normal", function( targetid )
	
		if vsoIsVehicleOwner( targetid ) then
		
			local eatid = vsoHasEatenId("drivingSeat");
			if eatid ~= nil then
				if eatid == targetid then
					--something else? ignore?
				else
					vsoUneat( "drivingSeat" );
					vsoEat( targetid, "drivingSeat" )
				end
			else
				vsoEat( targetid, "drivingSeat" )
			end
		end
		
	end )

	vsoOnDamage( "state_normal", function( damageRequest )

		damageRequest.damage = 0;	--But not "actually" hurt. Keep track of our OWN health (to fake it.)
		damageRequest.targetMaterialKind = "organic";	--material type

		changeAnims( { "hit", "idle" } )
		self.changeanims = true;

		if false then --"spit out victim if hit" for when we carry people in maw ,or are in the process of eating/pushing them 
			vsoUneat( "victimSeat" )
			vsoUseLounge( false, "victimSeat" )
		end
		--applyKnockback -> more complicated than desired (needs status controller update and such, refer to monster_primary npc_primary, player_primary)
		--[[
		if damageRequest.knockbackMomentum then

			local momentum = damageRequest.knockbackMomentum;
			local knockback = math.sqrt( momentum[1]*momentum[1] + momentum[2]*momentum[2] );
			if mcontroller.baseParameters().gravityEnabled and math.abs(momentum[1]) > 0  then
				local dir = momentum[1] > 0 and 1 or -1
				momentum = { dir * knockback / 1.41, knockback / 1.41 }

			mcontroller.addMomentum( momentum );
		end
		]]--

		return damageRequest;	--Didnt change anything here
	end )
end

-------------------------------------------------------------------------------

function onEnd()

	--vsoEffectWarpOut();

end

function state_normal()

	self.anim = vsoAnimCurr( "bodyState" );
	self.animended = vsoAnimEnd( "bodyState" );

	local eatid = vsoHasEatenId("drivingSeat");

    if (eatid ~= nil) then
		vehicle.setDamageTeam( world.entityDamageTeam(eatid) )
    else
		vehicle.setDamageTeam( {type = "passive"} )

		--Do something else? without a driver we should RETURN to the item from where we came...
		--How the heck do we do that?
		--Remove all eaten things
		--Act as if dead, but dont warp out...

		if self.anim ~= "hit" then
			changeAnims( { "hit" } )
			self.changeanims = true;
		end
		
		--apply an effect?
		if self.bellydirectives == self.firstdirectives then
			self.bellydirectives = "multiply=00000000;"..self.firstdirectives
			animator.setPartTag( "belly", "bellydirectives", "?"..self.bellydirectives )
			
		end

		--animator.setPartTag( "bg", "directives", "?".."multiply=00000000;" ) ??
		--animator.setPartTag( "fg", "directives", "?".."multiply=00000000;")
		
		--Uneat everything I have eaten
		local eatid = vsoHasEatenId("victimSeat");
		if eatid ~= nil then
			vsoUneat( "victimSeat" )
			vsoUseLounge( false, "victimSeat" )
		end
		
	  return;
    end

	local new_fall_through_platforms = self.fall_through_platforms;

	self.inputs = nil;

    if (eatid ~= nil) then

		self.inputs = vsoGetInput( "drivingSeat" )
		
		--tests here self.inputs
		--if self.inputs["1"] ~= 0 then sb.logInfo( "special 1! "..tostring( self.inputs["1"] ) ); end
		--if self.inputs["2"] ~= 0 then sb.logInfo( "special 2! "..tostring( self.inputs["2"] ) ); end
		--if self.inputs["3"] ~= 0 then sb.logInfo( "special 3! "..tostring( self.inputs["3"] ) ); end
		
	end

	if vsoUpdateTarget( "food", 1, -3, 3, 1, { monsters=true } ) then
		self.lasttarget = vsoGetTargetId( "food" );
	else
		self.lasttarget = nil;
	end

	state_normal_body();

    state_normal_controls()

	if #self.nextanims > 0 then
		if self.nextanims[1] ~= self.anim then	--This is REALLY BAD so...
			--self.changeanims = true;
		end
	end

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
			vsoAnim( "bodyState", self.anim )
		end
	end

	if self.anim == "duck" or self.anim == "duckcrawl" or self.anim == "run" or self.anim == "runopen" then
		if self.lastcollisionpolyname ~= "duck" then
			self.lastcollisionpoly = self.cfgVSO.movementSettings.duck;
			vsoMotionParam( self.lastcollisionpoly );--collision poly only ?
			self.lastcollisionpolyname = "duck"
		end
	else
		if self.lastcollisionpolyname ~= "stand" then
			self.lastcollisionpoly = self.cfgVSO.movementSettings.stand;
			vsoMotionParam( self.lastcollisionpoly );--collision poly only
			self.lastcollisionpolyname = "stand"
		end
	end

end

function state_normal_body()



end

function get_icon_directives( v, i )
	if v == i then
		return "?border=1;FFFFFF;FFFFFF"
	end
	return "?fade=FFFFFF00=0.33"
end

function get_icon_wobble( v, i )
	if v == i then
		return math.sin( 6.283185307179586476925286766559*vsoDeltaFromStart() )*15.0
	end
	return nil
end

function state_normal_controls()

	vsoAnim( "main", "invisible" )

	local new_fall_through_platforms = self.fall_through_platforms;

	if self.anim == "hit" and self.animended then

		changeAnim( "idle" )
	end

	--the NEXT FRAME, we must PUSH the player down iff if not ongroundmcont and self.previous_onground then
	--AKA "keeping them on the terrain"
	--NO WAIT
	--you JSUT HAVE TO HAVE THIS in the movement parameters
	--	,"slopeSlidingFactor" :0.0
	--	,"enableSurfaceSlopeCorrection" : true
	--
	
	local ongroundmcont = mcontroller.onGround(); --Not reliable... but why? whats the problem here?
	
	--[[
	if self.lastkeeponground then
		if not ongroundmcont then
			--Game thinks we are NOT on the ground.
			local usegpoly = self.cfgVSO.movementSettings.bottompoly.collisionPoly;--self.lastcollisionpoly.collisionPoly
			if usegpoly ~= nil then
				local collset = {"Block"}
				if not self.fall_through_platforms then
					collset = {"Block","Platform"}
				end
				local didhit = mMotionTestPolycast( usegpoly, mcontroller.position(), {0,-1}, 1.0, collset )
				if didhit ~= nil then
					sb.logInfo( "Applied correction" );
					mcontroller.translate( { 0, didhit[2] - mcontroller.yPosition() } );
				end
			end
		end
	end
	]]--
	self.lastkeeponground = false;
	
	local directonground = false;
	if self.lastcollisionpoly ~= nil then
		--Okay, this is REALLY tough. What is the "ground" polygon anyways?
		--Can we even "cut" the BOTTOM of the polygon off?
		--Huh...
		--"bottompoly"
		--"collisionPoly" : [ [2, -2.5], [1.5, -3], [-1.5, -3], [-2, -2.5] ]
		--"collisionPoly" : [ [2, -2.5], [1.5, -3], [-1.5, -3], [-2, -2.5] ]

		--Lets heavily manipulate it? Hm...
		local usegpoly = self.cfgVSO.movementSettings.bottompoly.collisionPoly;--self.lastcollisionpoly.collisionPoly
		local respoint = { mcontroller.xPosition(), mcontroller.yPosition() }
		local ytolerance = math.min( math.abs( mcontroller.xVelocity() ), 1.0 );
		if mcontroller.yVelocity() <= 0 then
			
			if self.fall_through_platforms then
				directonground = world.polyCollision( usegpoly, { mcontroller.xPosition(), mcontroller.yPosition() - ytolerance }, {"Block"} );
				--respoint = world.resolvePolyCollision(usegpoly, {mcontroller.xPosition(), mcontroller.yPosition() -1/64.0}, 1, {"Block"} )
			else
				directonground = world.polyCollision( usegpoly, { mcontroller.xPosition(), mcontroller.yPosition() - ytolerance }, {"Block","Platform"} );
				--respoint = world.resolvePolyCollision(usegpoly, {mcontroller.xPosition(), mcontroller.yPosition() -1/64.0}, 1, {"Block","Platform"} )
			end
		
		else
		
			--kinda problematic when you move UP a slope so you HAVE + velocity...
		end
		
		--the logic: resolution of collision should... what now?
		--if respoint ~= nil then
		--	if respoint[2] > (mcontroller.yPosition() -1/64.0) then
		--		directonground = true;
		--	end
		--end
	end
	
	local onground = ongroundmcont or directonground;
	
	--if onground then --or self.previous_onground then
	--	mcontroller.setYVelocity( -1/16.0 ); --well? jumps???
	--end
	
	if self.jumpacceldecay > 0 then
	
		if self.inputs.J > 0 and mcontroller.yVelocity() > 0 then
		
			--better algorithm is PIECES
			-- IE if you hold more than x, do high jump
			-- otherwise, short jump
		
			local prevdct = self.jumpacceldecay
			self.jumpacceldecay = self.jumpacceldecay - self.jumpacceldecayfactor * self.vsodt;
			
			if self.jumpacceldecay < 0 then
				self.jumpacceldecay = 0;
			end
			
			local deltadt = (prevdct - self.jumpacceldecay);
			
			local grav = world.gravity( mcontroller.position() );--MAY INCUR ERROR position)
			
			--jump AGAINST gravity? hm
			--This is a feel thing, a simple quadratic equation wont cut it really. Its more one of those e^* a * ln( b ) == a^b type problems.
			local vdelta = self.jumpacceldecay * ( self.jumpacceldecay * self.jumpacceldecayvelocity + grav )*deltadt - self.jumpacceldecayvelocityprev; --remove gravity component?
			self.jumpacceldecayvelocityprev = vdelta;
			mcontroller.setYVelocity( mcontroller.yVelocity() + vdelta );
			
			--deltadt is the time that has PASSED
			--based on parabolic equation...
			--y_pos = y0 + yv*t + va*t*t
			--yv = self.jumpacceldecayvelocity
			--y0 = 0;
			--va = (self.jumpacceldecay * self.jumpacceldecayvelocity)*dt
			
			--jumpacceldecay = 1.0 to 0.0
			
			--COMPUTE actual velocity based on time instead??? hm... can ignore physical effects...
			--local usevel = self.jumpacceldecayvelocityprev + self.jumpacceldecayvelocity * deltadt;
			--local delta = usevel - self.jumpacceldecayvelocityprev; --will be negative? Hm...
			--self.jumpacceldecayvelocityprev = usevel;
			--mcontroller.setYVelocity( mcontroller.yVelocity() + (usevel - self.jumpacceldecayvelocityprev) );
			
		else
			self.jumpacceldecay = 0;
		end
	end

    if self.anim ~= "hit" and (self.inputs ~= nil) then

		local inputs = self.inputs
		local skipdefaultcontrols = false;

		self.doubleTapInput = false;
		local newkeyscrap = {}
		newkeyscrap["left"] = inputs.L > 0
		newkeyscrap["right"] = inputs.R > 0
		self.doubleTap:update( self.vsodt, newkeyscrap )

		--Implementing a simple pie action menu! mouse controls only? Hm... sorta?

		local pie_action = nil;	--Default input action FIRST.
		
		--CONTEXT based pi:

		if inputs.B > 0 then

			self.pie_aim_position = vehicle.aimPosition( "drivingSeat" );

			self.pie_delta_x = self.pie_aim_position[1] - self.last_aim_position[1];
			self.pie_delta_y = self.pie_aim_position[2] - self.last_aim_position[2];

			local pieindex = -1;
			local piedistsq = self.pie_delta_x*self.pie_delta_x  + self.pie_delta_y*self.pie_delta_y;
			if piedistsq > 1 then

				--"pie_index_calculate"
				pieindex = pie_index_calculate( self.pie_delta_x, self.pie_delta_y, 8 )
			end

			--Activated! show pie of options...

			--CONTEXT SENSETIVE PIE ( detect things? state dependant? fight with victim? )

			vsoAnim( "main", "visible" )

			--Add flashing directives too?	?border=<pixels>;<innerColor>;<outerColor>

			vsoAnitag( "pieicon0image", "/objects/generic/woodendoor/woodendooricon.png"..get_icon_directives(pieindex,0) )
			vsoAnitag( "pieicon1image", "/items/generic/produce/carroticon.png"..get_icon_directives(pieindex,1) )
			vsoAnitag( "pieicon2image", "/projectiles/guns/unsorted/iceplasmarocket/icon.png"..get_icon_directives(pieindex,2) )
			vsoAnitag( "pieicon3image", "/objects/protectorate/objects/protectoratebrokenportrait3/protectoratebrokenportrait3icon.png"..get_icon_directives(pieindex,3) )
			vsoAnitag( "pieicon4image", "/objects/tiered/tier2bed/tier2bedicon.png"..get_icon_directives(pieindex,4) )
			vsoAnitag( "pieicon5image", "/interface/crafting/tabicon_lights.png"..get_icon_directives(pieindex,5) )
			vsoAnitag( "pieicon6image", "dinosuiticon.png"..get_icon_directives(pieindex,6) )
			vsoAnitag( "pieicon7image", "/interface/crafting/tabicon_mains.png"..get_icon_directives(pieindex,7) )

			--DONT FLIP transform group?
			local cx = self.last_aim_position[1] - mcontroller.xPosition();
			local cy = self.last_aim_position[2] - mcontroller.yPosition();
			local v1 = 4;
			local vq = v1*0.70710678118654752440084436210485;

			vsoTransSetNoFlip( "pieicon0trans", cx+v1, cy+0, get_icon_wobble(pieindex, 0) )
			vsoTransSetNoFlip( "pieicon1trans", cx+vq, cy+vq, get_icon_wobble(pieindex, 1) )
			vsoTransSetNoFlip( "pieicon2trans", cx+0, cy+v1, get_icon_wobble(pieindex, 2) )
			vsoTransSetNoFlip( "pieicon3trans", cx+-vq, cy+vq, get_icon_wobble(pieindex, 3) )
			vsoTransSetNoFlip( "pieicon4trans", cx+-v1, cy+0, get_icon_wobble(pieindex, 4) )
			vsoTransSetNoFlip( "pieicon5trans", cx+-vq, cy+-vq, get_icon_wobble(pieindex, 5) )
			vsoTransSetNoFlip( "pieicon6trans", cx+0, cy+-v1, get_icon_wobble(pieindex, 6) )
			vsoTransSetNoFlip( "pieicon7trans", cx+vq, cy+-vq, get_icon_wobble(pieindex, 7) )

		else
			local next_aim_position = vehicle.aimPosition( "drivingSeat" );

			if self.pie_aim_position ~= nil then

				self.pie_delta_x = self.pie_aim_position[1] - self.last_aim_position[1];
				self.pie_delta_y = self.pie_aim_position[2] - self.last_aim_position[2];

				local piedistsq = self.pie_delta_x*self.pie_delta_x  + self.pie_delta_y*self.pie_delta_y;
				if piedistsq > 1 then

					--"pie_index_calculate"
					local pieindex = pie_index_calculate( self.pie_delta_x, self.pie_delta_y, 8 )

					if pieindex >= 0 then
						local myactions = {
							"opendoor"	--right		--open doors?
							,"carrot"
							,"shoot"	--up
							,"heal"
							,"bed"		--left		--?
							,"idea"
							,"pathto"	--down		--go to this location if possible?
							,"tryeat"
						}
						pie_action = myactions[ 1 + pieindex ]

						--Auto-load appropriate targets? Hm...

					end

				end

				self.pie_aim_position = nil;
			else

				self.last_aim_position = next_aim_position
			end

		end

		--sb.logInfo( tostring( inputs.Etaps ).." E="..tostring( inputs.E ).." Etap="..tostring( inputs.Etap ));
		if inputs.E >= 1 then
			--vsoSay( tostring( vsoDeltaFromStart() ).." E! "..tostring( inputs.E ).." Es="..tostring( inputs.Etaps ).." Etap="..tostring( inputs.Etap ));
			--vsoSay( tostring( vsoDeltaFromStart() ).." E!");
		end
		
		if inputs.E == 1 and pie_action == nil then	--E input is VERY reliable now.
			pie_action = "idea";
			
			--Update last_aim_position to current cursor!
			self.last_aim_position = vehicle.aimPosition( "drivingSeat" );
			
		end

		if pie_action == "idea" then

			if vsoSimulatePlayerInteraction( self.vsoSpawnVehicleOwnerEntityId, self.last_aim_position, vsoDirection(), 4 ) then
				--yay?
			else
				--something else perhaps?
			end

		end

		local hasvictiminbelly = ( vsoHasEatenId( "victimSeat" ) ~= nil )
		if hasvictiminbelly then
		
			if self.bellydirectives ~= self.firstdirectives then
				self.bellydirectives = self.firstdirectives
				--animator.setGlobalTag( "bellydirectives", self.bellydirectives )
				animator.setPartTag( "belly", "bellydirectives", "?"..self.bellydirectives )
				--sb.logInfo( "belly directives ON" );
				--sb.logInfo( self.bellydirectives )
			end
		else
			if self.bellydirectives == self.firstdirectives then
				self.bellydirectives = "multiply=00000000;"..self.firstdirectives
				--animator.setGlobalTag( "bellydirectives", self.bellydirectives )
				animator.setPartTag( "belly", "bellydirectives", "?"..self.bellydirectives )
				
				--sb.logInfo( "belly directives OFF" );
				--sb.logInfo( self.bellydirectives )
			end
			
			if pie_action == "pathto" then
			
				--Two tries? 
				vsoUneat( "drivingSeat" );	--Hmm..
			
			end
			
		end

		if self.anim == "layfull" or self.anim == "layfullwig" then

			skipdefaultcontrols = true;

			if self.animended and self.anim ~= "layfull" then
				changeAnim( "layfull" );
			end

			if pie_action == "pathto"  and self.anim == "layfull" then
				vsoCounterReset( "squirming", 0, 100 )
				changeAnim( "full" );
			end

			local squirmdata = get_squirming_data( "victimSeat" );

			if squirmdata[2] > 0 then
				if squirmdata[2] == 2 then
					vsoSound( "please" );--emitlove = true
				else
					vsoSound( "struggle" );
					vsoTimerReset( "loveemit" )
				end
			end

			if squirmdata[3] then
				vsoCounterReset( "squirming", 0, 100 )
				changeAnim( "full" );
			elseif pie_action == "heal" and self.anim == "layfull" then
			
				local hurtid = vsoHasEatenId( "victimSeat" );
				if hurtid ~= nil then

					vsoSound( "purr" )
					changeAnim( "layfullwig" );	--hm.

					vsoResourceAddPercent( hurtid, "health", 5, function(stillalive) end );

				end
			elseif squirmdata[1] ~= nil then
				changeAnim( "layfullwig" );
			end

		elseif self.anim == "full" or self.anim == "fullwig" then

			skipdefaultcontrols = true;

			local victimid = vsoHasEatenId( "victimSeat" );
			if victimid ~= nil then

			else
				vsoCounterReset( "squirming", 0, 100 )
				vsoUneat( "victimSeat" )
				vsoUseLounge( false, "victimSeat" )

				changeAnim( "idle" );
			end

			if self.animended and self.anim ~= "full" then
				changeAnim( "full" );
			end

			if self.anim == "full" then

				if pie_action == "pathto" then
					vsoCounterReset( "squirming", 0, 100 )
					changeAnim( "sitfull" );
				end

				if pie_action == "carrot" then
					vsoCounterReset( "squirming", 0, 100 )
					changeAnim( "idle" );
				end

				if pie_action == "opendoor" then

					--pie_action = "release_victim";
					vsoUneat( "victimSeat" )
					vsoUseLounge( false, "victimSeat" )

					changeAnim( "idle" );
					--if vsoVictimAnimClearReady( "victimSeat", { -4.0, 0 }, true ) then
				elseif pie_action == "bed" then

					vsoCounterReset( "squirming", 0, 100 )
					changeAnim( "layfull" );

				elseif pie_action == "heal" then

					local hurtid = vsoHasEatenId( "victimSeat" );
					if hurtid ~= nil then

						vsoSound( "purr" )
						changeAnim( "fullwig" );	--hm.

						vsoResourceAddPercent( hurtid, "health", 5, function(stillalive) end );

					end

				elseif pie_action == "tryeat" then

					--Hmmm... for now, heal YOURSELF?
					local hurtid = vsoHasEatenId( "victimSeat" );
					if hurtid ~= nil then
						--(do 25% damage to victim in belly, recover 5% health?)
						--world.sendEntityMessage( hurtid, "applyStatusEffect", "vsodrainhealth25percent", 0.1, entity.id() );
						vsoSound( "digest" )
						changeAnim( "fullwig" );	--hm.

						--TrulyDigest victim: Hm...
						--world.sendEntityMessage( entity.id(), "applyStatusEffect", "vsohealhealth5percent", 0.1, entity.id() );

						--hm...
						--use MASS?
						local hashealths = world.entityHealth( hurtid );
						local maxpercent = 25.0;
						local damagepercent = 25.0;
						local damagecutoff = 100.0;
						if hashealths ~= nil then
							damagepercent = maxpercent*math.min( 1, damagecutoff/(1.0+hashealths[2]) );
						end
						
						
						--will this work for monsters?
						vsoResourceAddPercent( hurtid, "health", -damagepercent, function(stillalive)
							if not stillalive then

								if world.entityType( hurtid ) == "monster" then
									world.sendEntityMessage( hurtid, "despawn" );	--handle monsters differently
								elseif world.entityType( hurtid ) == "npc" then
									world.sendEntityMessage( hurtid, "applyStatusEffect", "vsokillnpcsit", 1.0, entity.id() );	--Only works on npc's
								end

								--async so...
								vsoCounterReset( "squirming", 0, 100 )
								vsoUneat( "victimSeat" )	--Dont forget you HAVE to uneat them for this to work...
								vsoUseLounge( false, "victimSeat" )
								changeAnim( "idle" );
								vsoSound("burp");
							else
								--
							end
						end );	--Change resource?

					end

				end
			end

			local squirmdata = get_squirming_data( "victimSeat" );

			if squirmdata[2] > 0 then
				if squirmdata[2] == 2 then
					vsoSound( "please" );--emitlove = true
				else
					vsoSound( "struggle" );
					vsoTimerReset( "loveemit" )
				end
			end

			if squirmdata[3] then
				vsoCounterReset( "squirming", 0, 100 )
				vsoUneat( "victimSeat" )
				vsoUseLounge( false, "victimSeat" )

				changeAnim( "idle" );
			elseif squirmdata[1] ~= nil then
				changeAnim( "fullwig" );
			end


		elseif self.anim == "sitfull" or self.anim == "sitfullwig" then

			skipdefaultcontrols = true;

			if self.animended and self.anim ~= "sitfull" then
				changeAnim( "sitfull" );
			end

			if pie_action == "pathto"  and self.anim == "sitfull" then
				vsoCounterReset( "squirming", 0, 100 )
				changeAnim( "full" );
			end

			local squirmdata = get_squirming_data( "victimSeat" );

			if squirmdata[2] > 0 then
				if squirmdata[2] == 2 then
					vsoSound( "please" );--emitlove = true
				else
					vsoSound( "struggle" );
					vsoTimerReset( "loveemit" )
				end
			end

			if squirmdata[3] then
				vsoCounterReset( "squirming", 0, 100 )
				changeAnim( "full" );
			elseif pie_action == "heal" and self.anim == "sitfull" then
			
				local hurtid = vsoHasEatenId( "victimSeat" );
				if hurtid ~= nil then

					vsoSound( "purr" )
					changeAnim( "sitfullwig" );	--hm.

					vsoResourceAddPercent( hurtid, "health", 5, function(stillalive) end );

				end
			
			elseif squirmdata[1] ~= nil then
				changeAnim( "sitfullwig" );
			end
				
		elseif self.anim == "bite" or self.anim == "bitemiss" then

			skipdefaultcontrols = true;

			if (self.anim == "bite") and self.animended then

				vsoCounterReset( "squirming", 0, 100 )

				local eatid = vsoHasEatenId("victimSeat");

				if eatid then

				else

					--did we hit someone?
					local whoweeating = self.lasttarget;	--#may not be safe

					--sb.logInfo( tostring( whoweeating ) );

					if whoweeating then--#vsoUpdateTarget( "food", 1, -2, 3, 1 ) then

						--Are they a monster? Hm...

						vsoUseLounge( true, "victimSeat" )
						vsoEat( whoweeating, "victimSeat" )

						vsoSound("eatchomp");

						vsoTimerSet( "gurgle", 0.5, 5 )	--For playing sounds

						vsoVictimAnimVisible( "victimSeat", false )
						--vsoAnim( "bodyState", "playereat" );
						--vsoVictimAnimReplay( "victimSeat", "playereat", "bodyState" )
						changeAnim( "full" );
					end
				end
			elseif self.anim == "bitemiss" and self.animended then
				changeAnim( "idle" );
				skipdefaultcontrols = false;
			end
		else
			if hasvictiminbelly then

				if pie_action == "carrot" then
					changeAnim( "full" );
				end
				
				if pie_action == "tryeat" then
					changeAnim( "full" );
				end

				if pie_action == "opendoor" then
					changeAnim( "idle" );
					vsoCounterReset( "squirming", 0, 100 )
					vsoUneat( "victimSeat" )
					vsoUseLounge( false, "victimSeat" )
				end
			end
		end

		--inputs.L	left
		--inputs.R	right
		--inputs.U	up
		--inputs.D	down
		--inputs.J	jump
		--inputs.A	a (primary attack)
		--inputs.B	b (secondary attack)
		--inputs.E--Tap it a lot to "quit" vehicle... huh...

		--WEll, this should be broken out into states... a lot of functionality is shared.
		--Also, moveset programming is a bit weird/complicated.
		--The problem here is "input" -> "control" needs to be separated.
		--IE, only set the necessary values from this, so that AI can generate those same controls.
		--

		if pie_action == "opendoor" then

			--requires doors to query
			local doors = vsoSimulatePlayerQueryFirstDoorAhead( vsoDirection(), 1.0 );
			
			if doors then
				vsoSimulatePlayerToggleDoorsAhead( doors[1], doors[2] );
			
			end
			
			--triggers MANY times in a row.

			--Attempt to "interact" through player passthrough?
			--IE pass the position of the mouse and send a player interact?
			--How do we know what is highlighted for this player?
			--world.objectLineQuery(Vec2F startPosition, Vec2F endPosition, [Json options])
			--world.callScriptedEntity(switch, "onInteraction")

			--sb.logInfo( "E tapped "..tostring( inputs.E ) );

			--activeItem.ownerAimPosition()   <-

			--Opening doors eh?
			--pie_action = "opendoor";
			
			--if vsoSimulatePlayerToggleDoorsAhead( vsoDirection(), 0.0 ) then

			--else

				--huh!

			--end

		end

		local dx = inputs.R - inputs.L;
		if dx > 0 then dx = 1; elseif dx < 0 then dx = -1; end	--analog scaling maybe?
		local yvel = mcontroller.yVelocity();

		new_fall_through_platforms = false;

		if not skipdefaultcontrols and onground then

			if self.anim == "run" or self.anim == "runopen" then

				--Have to STOP holding direction?
				--How to detect double tap?

				if dx ~= 0 then

					if inputs.A > 0 then

						changeAnim( "runopen" );
					else

						changeAnim( "run" );
					end

					vsoFaceDirection( dx );
					self.xvelocity = self.runspeedfactor * self.xspeed * dx

				else
					self.running = false;
					changeAnim( "idle" );
				end

			elseif self.anim == "walk" then

				--Walking means we have special attacks? Hm...
				if pie_action == "tryeat" or inputs.A > 0 or inputs.B > 0 then

					--Action!
					self.xvelocity = 0;

					if pie_action == "tryeat" or inputs.A > 0 then
						local eatid = vsoHasEatenId("victimSeat");
						if eatid then
						else
							--pie_action = "bite";
							self.xvelocity = 0;
							changeAnims( { "bite", "bitemiss" } );
						end
					end

				else

					if dx ~= 0 then

						--pie_action = "walk";
						vsoFaceDirection( dx );
						self.xvelocity = self.xspeed * dx

					else

						changeAnim( "idle" );
					end

				end

			elseif self.anim == "duck" or self.anim == "duckcrawl" then

				self.running = false;

				--Cannot move left or right yet?
				if inputs.A > 0 or inputs.B > 0 then

					--Action!
					self.xvelocity = 0;

					--pie_action = "duck_bite";

				else
					if inputs.D > 0 then

						--pie_action = "duck";

						if dx ~= 0 then
							changeAnim( "duckcrawl" );
							vsoFaceDirection( dx );
							self.xvelocity = self.duckspeedfactor * self.xspeed*dx;	--uhhhhh
						else
							changeAnim( "duck" );
							self.xvelocity = 0;
						end


					else
						--pie_action = "unduck";
						changeAnim( "idle" );
					end
				end

			else

				if pie_action == "tryeat" or inputs.A > 0 or inputs.B > 0 then

					--Action!
					if pie_action == "tryeat" or inputs.A > 0 then
						local eatid = vsoHasEatenId("victimSeat");
						if eatid then
						else
							--pie_action = "bite";
							self.xvelocity = 0;
							changeAnims( { "bite", "bitemiss" } );
						end
					end

				else

					if dx ~= 0 then vsoFaceDirection( dx ); end

					if self.running then
						self.xvelocity = self.runspeedfactor * self.xspeed * dx
					else
						self.xvelocity = self.xspeed * dx
					end

					if dx ~= 0 then
						--pie_action = "walk";
						if self.running then
							changeAnim( "run" );
						else
							changeAnim( "walk" );
						end
					else
						--pie_action = "idle";
						changeAnim( "idle" );
					end

				end

			end

			--Running only occurs if you are idle/walking?
			if self.anim == "walk" or self.anim == "idle" then

				if self.doubleTapInput then
					changeAnim( "run" );
					self.running = true;
				end
			end


			if inputs.D > 0 and inputs.J > 0 and not self.fall_through_platforms then

				new_fall_through_platforms = true;	--fall through platforms? "ignorePlatformCollision"

			elseif inputs.J > 0 then

				--pie_action = "jump";
				self.jumpacceldecay = 1.0;
				self.jumpacceldecayvelocityprev = self.jumpacceldecayvelocity;
				mcontroller.setYVelocity( self.jumpacceldecayvelocityprev );--self.yjumpvelocity ); --HM! time dependant jump height... IE apply decaying acceleration to y velocity?
				onground = false; --NO LONGER on ground by definition
				self.previous_onground = false; --NO CHECKING for movement this way
				
			elseif inputs.D > 0 then

				--pie_action = "duck";
				--changeAnim( "duck" );
				self.running = false;
				if dx ~= 0 then
					changeAnim( "duckcrawl" );
					vsoFaceDirection( dx );
					self.xvelocity = self.duckspeedfactor * self.xspeed*dx;	--uhhhhh
				else
					changeAnim( "duck" );
					self.xvelocity = 0;
				end
			end

		elseif not skipdefaultcontrols then

			if pie_action == "tryeat" or inputs.A > 0 or inputs.B > 0 then

				--Action! Hm...
				if pie_action == "tryeat" or inputs.A > 0 then
					local eatid = vsoHasEatenId("victimSeat");
					if eatid then

					else
						--pie_action = "bite";
						self.xvelocity = 0;
						changeAnims( { "bite", "bitemiss" } );
					end
				end
			else

				--if dx > 0 then dx = 1; vsoFaceDirection( dx ); elseif dx < 0 then dx = -1; vsoFaceDirection( dx ); end
				if self.running then
					self.xvelocity = self.runspeedfactor * self.xspeed * dx
				else
					self.xvelocity = self.xspeed * dx
				end
			end
			
			--well... only if we WERE jumping...
			if yvel > 0 then
				changeAnim( "jumpup" );
			else
				changeAnim( "jumpdown" );
			end

		end

		if inputs.D > 0 and self.fall_through_platforms then

			new_fall_through_platforms = true;	--fall through platforms? "ignorePlatformCollision"
		end

		--Fun fact... if we want to handle SLOPS correctly...
		--Well... "pushing" along X into any sharp edge is gonna be a problem. We need to "Slide" up slopes?

		--The reality SEEMS TO BE that we have to compute the NEXT position ourselves...
		--But it HAS to be ON THE GROUND and it has to SLIDE UP SLOPES without impacting forward velocity...
		--Kinda weird... edge traversal for positions???

		mcontroller.approachXVelocity( self.xvelocity, mcontroller.mass() * self.xvelocityforce );
		
		--Okay fine...
		--Need MORE specialized routines...
		--the reality is, we have a xvelocity for the motion.
		--the NEXT FRAME, we must PUSH the player down iff if not ongroundmcont and self.previous_onground then
		--AKA "keeping them on the terrain"
		
		self.lastkeeponground = not ongroundmcont and self.previous_onground;
		
		--[[

		--This isnt QUITE cutting it weirdly.
		--Some sort of sign bias.
		if not ongroundmcont and self.previous_onground then
		
			local downdistance = mTestdistanceToGround( mcontroller.position(), 10 );
			
			--sb.logInfo( "ledgefall "..tostring( mcontroller.yVelocity() ).." "..tostring( downdistance ) );
			local lbb = mcontroller.localBoundBox() 
		
			sb.logInfo( tostring(lbb) );
			
			if downdistance < 9 and downdistance > 3 then --NOTE we know the bounding box LOW.
				mcontroller.translate( { 0, 3-downdistance  } ); --Then move UP until NOT colliding?
				onground = true;
			end
			
			
			local usepoly = nil;
			if self.lastcollisionpoly ~= nil then
				usepoly = self.lastcollisionpoly.collisionPoly
			end
			
			--Check for possible previous correction
			--mcontroller.addMomentum( { 0, upmove - 1/16.0  } )
			local collset = {"Block"}
			if not self.fall_through_platforms then
				collset = {"Block","Platform"};
			end
			
			local ymaxcorr = 1.0;
			local ymove = 1/16.0;
			while ymove <= 1.0 do
				if not world.polyCollision( usepoly, { mcontroller.xPosition(), mcontroller.yPosition() - ymove }, collset ) then
					ymove = ymove + 1/16.0;
				else
					mcontroller.translate( { 0, -ymove + 1/16.0  } )
					sb.logInfo( "downcorrection" );
					break;
				end
			end
		
		elseif self.previous_onground then

			--Hm... we slide on a slope. This isnt good.
			--Have absolutely no idea how to correct that...
			local usepoly = nil;
			if self.lastcollisionpoly ~= nil then
				usepoly = self.lastcollisionpoly.collisionPoly
			end
			
			--Apply an IMMEDIATE correction?
			
			
			if mMoveLikeActorController( self.vsodt, self.fall_through_platforms or new_fall_through_platforms, usepoly ) then	--listens to x and y velocity.
			
				onground = true;--Applied a correction
				
			else
				--did NOT apply a correction
				
			end--onground
			
		end
		]]--

		--local deltax = self.xvelocity * self.vsodt;
		--local deltay = 0;

		--mcontroller.setYVelocity( self.yjumpvelocity )
		--mcontroller.setXVelocity( ? )

		--local collbounds = mcontroller.collisionBoundBox()
		--local polybody = mcontroller.collisionBody();


		--deltax = self.vsodt * velocity
		--deltay = self.vsodt * velocity  ??
		--
		--mcontroller.setXPosition( mcontroller.xPosition() + deltax );
		--mcontroller.setYPosition( mcontroller.yPosition() + deltay );

		if false then--onground then

			local facingdir = vsoDirection();
			local bounds = vsoGetBoundsAhead( 0, 0.0 );
			local yepsilon = 0.015625;
			local boundsz = { bounds[1]+yepsilon, bounds[2]+yepsilon, bounds[3]-yepsilon, bounds[4]-yepsilon }

			local xcell = boundsz[3]
			local ycell = boundsz[2];

			if facingdir >= 0 then
				xcell = boundsz[3]
				facingdir = 1;
			else
				xcell = boundsz[1]
				facingdir = -1;
			end

			--world.tileIsOccupied( {xcelltile, ycelltile }, false, false )
			local nextis = world.pointTileCollision( {xcell+facingdir, ycell }, {"Block"} )
			local nextupis = world.pointTileCollision( {xcell+facingdir, ycell+1 }, {"Block"} )
			local nextdownis = world.pointTileCollision( {xcell+facingdir, ycell-1 }, {"Block"} )

			--sb.logInfo( tostring( nextis ).." "..tostring( nextupis ).." "..tostring( nextdownis ).." TSHOT" )

			if nextis and not nextupis then
				--Move UP (until not colliding)
				local deltax = mcontroller.xVelocity() * self.vsodt;
				local deltay = math.abs( deltax )
				--Calculate deltay required (if collision box is NOT perfectly 45 degrees this fails?)
				mcontroller.setYPosition( mcontroller.yPosition() + deltay )


			elseif not nextis and not nextdownis then
				--Move DOWN (until colliding)
				local deltax = mcontroller.xVelocity() * self.vsodt;
				local deltay = math.abs( deltax )
				mcontroller.setYPosition( mcontroller.yPosition() - deltay )

			end

		end

		if false then

			--Huh... not sure how to do this.
			local bounds = vsoGetBoundsAhead( 0, 0.0 );


			local deltax = mcontroller.xVelocity() * self.vsodt;
			local deltay = math.abs( deltax )
			local yepsilon = 0.015625;
			local boundsx0 = { bounds[1]+yepsilon, bounds[2]+yepsilon, bounds[3]-yepsilon, bounds[4]-yepsilon }

			local boundsysnap = { bounds[1], math.floor(bounds[2]), bounds[3], math.floor(bounds[2]) + 1 }-- - (bounds[2] % 1)
			local boundsysnapp1 = { boundsysnap[1]+facingdir, boundsysnap[2]+1, boundsysnap[3]+facingdir, boundsysnap[4]+1 }
			local boundsysnapm1 = { boundsysnap[1]+facingdir, boundsysnap[2]-1, boundsysnap[3]+facingdir, boundsysnap[4]-1 }

			--Look forward 1 TILE? huh...
			local boundsx1 = { boundsx0[1] + facingdir, boundsx0[2], boundsx0[3] + facingdir, boundsx0[4] }
			local boundsx1y1 = { boundsx1[1], boundsx0[2]+deltay, boundsx1[3], boundsx0[4]+deltay }
			local boundsx1yn1 = { boundsx1[1], boundsx0[2]-deltay, boundsx1[3], boundsx0[4]-deltay }

			if not world.rectTileCollision( boundsysnap, {"Block"} ) then

				local nexthit = world.rectTileCollision( boundsx1, {"Block"} )

				if nexthit and not world.rectTileCollision( boundsysnapm1, {"Block"} ) then
					deltay = -deltay	--Moving DOWN block staircase...
				elseif nexthit and not world.rectTileCollision( boundsysnapp1, {"Block"} ) then
					--deltay = deltay	--Moving UP block staircase...
				else
					deltay = 0;
				end
				mcontroller.setYPosition( mcontroller.yPosition() + deltay )
			end
		end

	elseif self.anim ~= "hit" then

		--Nothing? Act like a normal SPOV thing? Huh...

	end
	
	if self.fall_through_platforms ~= new_fall_through_platforms then
		self.fall_through_platforms = new_fall_through_platforms
		vsoMotionParam( { ignorePlatformCollision = self.fall_through_platforms } );
	end

	self.previous_onground = onground;--mcontroller.onGround(); --Not reliable...onground

end
