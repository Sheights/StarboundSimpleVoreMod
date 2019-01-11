require "/scripts/behavior.lua"
require "/scripts/pathing.lua"
require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/scripts/poly.lua"
require "/scripts/drops.lua"
require "/scripts/status.lua"
require "/scripts/tenant.lua"
require "/scripts/vore/monstervore.lua"

function setApplyTouchDamage( v )
	monster.setDamageOnTouch( v );
	self.touchDamageEnabled = v;	--HEY LOOK, a hack
end

function initHook()
	
	--STATE MACHINE based AI	
	self.sensors = sensors.create()

	self.state = stateMachine.create({
		"moveState",
		"fleeState",
		"layState"
	})

	self.state.leavingState = function(stateName)
		animator.setAnimationState("movement", "idle")
	end
	monster.setAggressive( false )
	animator.setAnimationState("movement", "idle")
	--END

  
	setSearchBounds( config.getParameter("voreBounds")[ "default" ] );
	
	setApplyTouchDamage( true );
	
	self.feedwait = 1.0;	--Pick random feeding wait times
	self.feedready = 0;

end

	--STATE MACHINE based AI	
function shouldDie()
	return status.resource("health") <= 0;
end

function die()
	--capturable.die()
end

function damage(args)
	if status.resourcePositive("health") then
		self.state.pickState( { targetId = args.sourceId } );
	end
end

function move(direction, run)
	mcontroller.controlMove( direction, run );
end
--END


--STATE MACHINE based AI	
--------------------------------------------------------------------------------
moveState = {}

function moveState.enter()

  local direction
  if math.random(100) > 50 then
    direction = 1
  else
    direction = -1
  end

  return {
    timer = util.randomInRange(config.getParameter("moveTimeRange")),
    direction = direction
  }
end

function moveState.update(dt, stateData)
  if self.sensors.blockedSensors.collision.any(true) then
    stateData.direction = -stateData.direction
  end

  animator.setAnimationState("movement", "move")
  move(stateData.direction, false)

  stateData.timer = stateData.timer - dt
  if stateData.timer <= 0 then

    if math.random(100) <= config.getParameter("eggPercentageChancePerMove") then
      self.state.pickState({eggtimer = 3.0})
    else
      return true, 1.0    --idle then re-enter ?
    end

  end

  return false
end


--------------------------------------------------------------------------------
fleeState = {}

function fleeState.enterWith(args)
  if args.targetId == nil then return nil end --if no target ide is passed in bang out
  if self.state.stateDesc() == "fleeState" then return nil end --if we're already flkeeing, bang out

  return {                              --return some parameters applicable to this state.
    targetId = args.targetId,
    timer = config.getParameter("fleeMaxTime"),
    distance = util.randomInRange(config.getParameter("fleeDistanceRange"))
  }
end

function fleeState.update(dt, stateData)
  animator.setAnimationState("movement", "run")

  local targetPosition = world.entityPosition(stateData.targetId)
  if targetPosition ~= nil then
    local toTarget = world.distance(targetPosition, mcontroller.position())
    if world.magnitude(toTarget) > stateData.distance then
      return true
    else
      stateData.direction = -toTarget[1]
    end
  end

  if stateData.direction ~= nil then
    move(stateData.direction, true)
  else
    return true
  end

  stateData.timer = stateData.timer - dt
  return stateData.timer <= 0
end


--------------------------------------------------------------------------------
layState = {}

function layState.enterWith(args)
  if args.targetId ~= nil then return nil end --if a target id is passed in bang out
  if args.eggtimer == nil then return nil end --if a timer is NOT passed in bang out
  if self.state.stateDesc() == "layState" then return nil end --if we're already laying, bang out


  return {
    timer = args.eggtimer
  }
end

function layState.update(dt, stateData)


  if stateData.timer > 0 then
    animator.setAnimationState("movement", "lay")
    stateData.timer = stateData.timer - dt
  else
    if animator.animationState("movement")=="idle" then
      
      --spawn an egg of some kind
      local eggType = config.getParameter("eggType")

      world.spawnItem(eggType, mcontroller.position(), 1)

      return true;    --meaning pick new state
    end

    animator.setAnimationState("movement", "egg")
  end

  return false;
end

--END

function feedHook()
	--sb.logInfo( "smoglinz MV feedHook" );
	
	monster.say( "*Delicious!" );	--Can use replace tags to say victims name and such
	
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

	self.state.update(dt)
	self.sensors.clear()

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
	else
	
		self.behaviorTick = 0;	--HACK should stop behavior from updating
		mcontroller.clearControls();	--HACK remove control inputs
		animator.setAnimationState( "body", "vorefull", false );

	end
	
end

function interactHook()
	--sb.logInfo( "smoglinz MV interactHook" );
	
end

