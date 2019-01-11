require "/scripts/rect.lua"

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--pathing.canOpenDoors
--pathing.forceWalkingBackwards

--Required to abstract out the difference between vehicles and npc/player. Gets the motion parameters
function mParams()
	local MP = ( mcontroller.baseParameters or mcontroller.parameters )();
	--SOME THINGS will be missing. And we CANNOT use mcontroller.parameters to access them, so.
	--#ERROR fix this later.
	if MP.airJumpProfile == nil then
		MP.airJumpProfile = {
			jumpSpeed = 34
			,jumpControlForce = 40
		}
	end
	
	if MP.liquidJumpProfile == nil then
		MP.liquidJumpProfile = {
			jumpSpeed = 4
			,jumpControlForce = 10
		}
	end
	
	if MP.groundForce == nil then	--MUST EXIST?!?!
		MP.groundForce = 400
	end
	--if MP.gravityEnabled == nil then
	--	MP.gravityEnabled = true		--UH.
	--end

	--"walkSpeed" : 10,
	--"runSpeed" : 10,

	--"jumpSpeed" : 5,
	--"flySpeed" : 3,

	return MP;
end

--Required to abstract out the difference between vehicles and npc/player. Gets the bounding box
function mBoundBox()
	return (mcontroller.boundBox or mcontroller.localBoundBox)()
end

--Required to abstract out the difference between vehicles and npc/player. Gets the facing direction (vehicles dont have this)
function mFacingDirection()
	if mcontroller.facingDirection ~= nil then
		return mcontroller.facingDirection()
	else
		return self.vsoCurrentDirection
	end
end

function mControlFace( dir )
	if mcontroller.controlFace ~= nil then
		mcontroller.controlFace(self.pather.deltaX or toTarget[1])
	else
		vsoFacePoint( mcontroller.position()[1] + dir )
	end
end

function mMovingFacing( )
	if mcontroller.movingDirection ~= nil then
		return mcontroller.movingDirection()
	else
		return vsoDirection();
	end
end

function mJumpModifyer()
	if status ~= nil then
		return status.stat("jumpModifier")
	else
		return 0.0;	--What da
	end
end

function mMotionParameters()
	if self.options ~= nil then 
		if self.options.movementParameters ~= nil then
			return self.options.movementParameters
		else
			return mParams();
		end
	else
		return mParams();
	end
end

function mMotionParametersSet( dats )

	if mcontroller.controlParameters ~= nil then
		mcontroller.controlParameters( dats )
	else
		local someshit = mcontroller.parameters()
		local useem = {
			airFriction = 0
			,liquidFriction = 0.2
			,liquidImpedance = 0
			,groundFriction = 40
			,groundForce = 400
		}
		if someshit.airFriction ~= nil then useem.airFriction = someshit.airFriction end
		if someshit.liquidFriction ~= nil then useem.liquidFriction = someshit.liquidFriction end
		if someshit.liquidImpedance ~= nil then useem.liquidImpedance = someshit.liquidImpedance end
		if someshit.groundFriction ~= nil then useem.groundFriction = someshit.groundFriction end
		if someshit.groundForce ~= nil then useem.groundForce = someshit.groundForce end
		
		mcontroller.applyParameters( useem );
	end
end

function mLiquidCheck()
	if mcontroller.liquidMovement then
		return mcontroller.liquidMovement();
	else
		local submerged = mcontroller.liquidId()	--No equivalent
		--mcontroller.liquidPercentage()
		if submerged ~= nil then
			return true;
		else
			return false;
		end
	end
end

--told to move
function moveX(direction, running)
	if mcontroller.controlMove ~= nil then
		mcontroller.controlMove( direction, running )
	else
		--OK soooooo
		self.motionControls.xrunning = running;
		
		if direction < 0 then self.motionControls.x = -1; end
		if direction > 0 then self.motionControls.x = 1; end
		
		--self.motionControls.y = direction;	--moveX
		--self.motionControls.x = direction;	--moveX
		--mcontroller.controlMove(util.toDirection(toTarget[1]), true)
	end
end

function mControlDown()	--mcontroller.controlDown() == ignore platforms or not
	if mcontroller.controlDown ~= nil then
		mcontroller.controlDown()
	else
		self.motionControls.dropDown = 1;
	end
	--"ignorePlatformCollision" : true,
	--mcontroller.applyParameters( self.cfgVSO.movementSettings.default );
end

function mControlApproachXVel( vel, forceval )
	--REQUIRES "groundForce" value
	if mcontroller.controlApproachXVelocity ~= nil then
		mcontroller.controlApproachXVelocity( vel, forceval );
	else
		mcontroller.approachXVelocity( vel, forceval );
	end
end

function mControlApproachYVel( vel, forceval )
	
	if mcontroller.controlApproachYVelocity ~= nil then
		mcontroller.controlApproachYVelocity( vel, forceval );
	else
		mcontroller.approachYVelocity( vel, forceval );
	end
end

function mControlJump()
	if mcontroller.controlJump ~= nil then
		mcontroller.controlJump();
	else
		--Hmmmm
        --mControlApproachYVel( velocity[2], mParams().airJumpProfile.jumpControlForce )
	end
end

function mControlJumpHold()
	if mcontroller.controlHoldJump ~= nil then
		mcontroller.controlHoldJump();
	else
		--Hmmmm
	end
end

function mSetVelocity( newvel )

	mcontroller.setVelocity( newvel );
end

--mcontroller.controlFly(vec2.mul(vec2.norm(self.delta), mParams().flySpeed), mParams().airForce)
--mcontroller.controlApproachYVelocity(velocity[2], mParams().airJumpProfile.jumpControlForce)
--mcontroller.controlApproachVelocity(vec2.mul(vec2.norm(self.delta), mParams().walkSpeed), mParams().liquidJumpProfile.jumpControlForce)


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--The time it would take to fall distance
function timeToFall(distance)
  local gravity = world.gravity(mcontroller.position())
  return math.sqrt(2 * distance / gravity)
end

--Checks if the entity can stand in this position
function validStandingPosition(position, avoidLiquid, collisionSet, bounds)
  collisionSet = collisionSet or {"Null", "Block"}
  bounds = bounds or mBoundBox()

  local boundRegion = rect.translate(bounds, position)
  local groundRegion = {
    position[1] + bounds[1], position[2] + bounds[2] - 1,
    position[1] + bounds[3], position[2] + bounds[2]
  }
  if (world.rectTileCollision( groundRegion, {"Null", "Block", "Dynamic", "Platform"} ) or (not avoidLiquid and world.liquidAt(position)))
     and not world.rectTileCollision(boundRegion, collisionSet)  then
    return true
  end
  return false
end

--Find a valid ground position
function findGroundPosition(position, minHeight, maxHeight, avoidLiquid, collisionSet, bounds)
  bounds = bounds or mBoundBox()

  -- Align the vertical position of the bottom of our feet with the top
  -- of the row of tiles below:
  position = {position[1], math.ceil(position[2]) - (bounds[2] % 1)}

  local groundPosition
  for y = 0, math.max(math.abs(minHeight), math.abs(maxHeight)) do
    -- -- Look up
    if y <= maxHeight and validStandingPosition({position[1], position[2] + y}, avoidLiquid, collisionSet, bounds) then
      groundPosition = {position[1], position[2] + y}
      break
    end
    -- Look down
    if -y >= minHeight and validStandingPosition({position[1], position[2] - y}, avoidLiquid, collisionSet, bounds) then
      groundPosition = {position[1], position[2] - y}
      break
    end
  end

  if groundPosition and avoidLiquid then
    local liquidLevel = world.liquidAt(rect.translate(bounds, groundPosition))
    if liquidLevel and liquidLevel[2] >= 0.1 then
      return nil
    end
  end

  return groundPosition
end

--Check if entity is on solid ground (not platforms) 
function onSolidGround()
  local position = mcontroller.position()
  local bounds = mBoundBox()

  local groundRegion = {
    position[1] + bounds[1], position[2] + bounds[2] - 1,
    position[1] + bounds[3], position[2] + bounds[2]
  }
  return world.rectTileCollision(groundRegion, {"Null", "Block", "Dynamic"})
end

function padBoundBox(xPadding, yPadding)
  local bounds = mBoundBox()
  bounds[1] = bounds[1] - xPadding
  bounds[3] = bounds[3] + xPadding
  bounds[2] = bounds[2] - yPadding
  bounds[4] = bounds[4] + yPadding
  return bounds
end
