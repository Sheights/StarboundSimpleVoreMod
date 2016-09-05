require "/scripts/behavior.lua"
require "/scripts/pathing.lua"
require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/scripts/poly.lua"
require "/scripts/drops.lua"
require "/scripts/status.lua"
require "/scripts/companions/capturable.lua"
require "/scripts/tenant.lua"
require "/scripts/vore/monstervore.lua"

function setApplyTouchDamage( v )
	monster.setDamageOnTouch( v );
	self.touchDamageEnabled = v;	--HEY LOOK, a hack
end

function initHook()
	
	setSearchBounds( config.getParameter("voreBounds")[ "default" ] );
	
	setApplyTouchDamage( true );
	
	self.feedwait = 1.0;	--Pick random feeding wait times
	self.feedready = 0;

end

function feedHook()
	--sb.logInfo( "smoglinz MV feedHook" );
	
	monster.say( "...Delicious~..." );	--Can use replace tags to say victims name and such
	
end

function digestHook()
	--sb.logInfo( "smoglinz MV digestHook" );
end

function gainHook()
	
	--sb.logInfo( "smoglinz MV gainHook "..tostring( isFed() ).." "..tostring( isFed ) );
	
	monster.setInteractive( true );	
	
	self.behaviorTick = 0;	--HACK should stop behavior from updating
	mcontroller.clearControls();	--HACK remove control inputs
	
	animator.setAnimationState( "body", "vorefull", false );
	
	setApplyTouchDamage( false );
	self.feedready = 0;
	
end

function loseHook()
	--sb.logInfo( "smoglinz MV loseHook" );
	
	self.feedwait = 1.0 + math.random(6);	--Should WAIT a while. Yup
	self.feedready = 0;
	
	monster.setInteractive( false );	
	
	setApplyTouchDamage( true );
	
end

function updateHook(dt)

	if not isFed() then
		if self.feedwait < 0 then
		
			if self.feedready == 0 then
				self.feedready = 1;	--must be integer
				
				--status.addEphemeralEffect( "colorred", 0.5, entity.id() );
				status.addEphemeralEffect( "redflash", 0.85, entity.id() );	--From rage and redflash stat
				--effect.setParentDirectives("fade=ff0000=0.85");	--Actually uses this directive; A direct red flash
				animator.playSound("growl");
				
			end
			
			attemptFeed();	-- Can automate feed delays and stuff
			
			self.feedwait = -1;
		else
			self.feedwait = self.feedwait  - dt;
		end
		
		--animator.setAnimationState( "voredisplaybar", "off", false );
	else
	
		--Interesting idea, WAY too agressive. Need a way to flip this bit however.
		--world.sendEntityMessage( self.victim, "applyStatusEffect", "npcacid", 1, entity.id() );
				
		self.behaviorTick = 0;	--HACK should stop behavior from updating
		mcontroller.clearControls();	--HACK remove control inputs
		animator.setAnimationState( "body", "vorefull", false );
		
		--Might have to build this into the creature. Want to interpolate bar AND color...
		--so, that should work. It's a bit hacky. And isn't consistent with the UI stuff. 
		--Hm.
		--animator.setAnimationState( "voredisplaybar", "on", false );
		--animator.transformTransformationGroup( "voredisplaybar", 1, 0, 0, 1, 0, 0);	--a,b,c,d,tx,ty
	end
	
end


--EntityId world.spawnStagehand(Vec2F position, String type, [Json overrides])
--?
--	ScriptPane
--		Widget
--

function interactHook()
	--sb.logInfo( "smoglinz MV interactHook" );
	
end

