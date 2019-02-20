--This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
--https://creativecommons.org/licenses/by-nc-sa/2.0/  @ ZMakesThingsGo & Sheights

require "/scripts/rect.lua"

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--So many issues.
--A "vehicle" has different instructions than a NPC/Player/Actor
--
--	The mcontroller table sometimes contains functions relating to the actor movement controller. 
--		https://starbounder.org/Modding:Lua/Tables/Actormovementcontroller
--		controlMove
--		controlFace
--		controlDown
--		controlCrouch
--		controlJump
--		controlModifiers
--
--	VEHICLE:
--		vehicle.controlHeld(String loungeName, String controlName)
--		So yeah.

--pathing.canOpenDoors
--pathing.forceWalkingBackwards

--Required to abstract out the difference between vehicles and npc/player. Gets the motion parameters
function mParams()

	local MP = nil;
	if mcontroller.baseParameters then
		MP = mcontroller.baseParameters()	--Actor
		--sb.logInfo( "Thing is a Actor: "..tostring( entity.id() ) )
	else
		MP = mcontroller.parameters()	--vehicle
		--Meaning we need EXTRA parameters if we have them...
		--sb.logInfo( "Thing is a Vehicle: "..tostring( entity.id() ) )
	end
	
	--SOME THINGS will be missing. And we CANNOT use mcontroller.parameters to access them, so.
	
	--Shared between vehicldes and actors:
	if MP.airFriction == nil then MP.airFriction = 0.001 end
	if MP.liquidFriction == nil then MP.liquidFriction = 0.2 end
	if MP.liquidImpedance == nil then MP.liquidImpedance = 0.1 end
	if MP.groundFriction == nil then MP.groundFriction = 40 end
	if MP.groundForce == nil then MP.groundForce = 400 end
	if MP.gravityEnabled == nil then MP.gravityEnabled = true end
	
	--NOT shared between actors and vehicles.
	if mcontroller.baseParameters then
		--Actor
		
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
		
		if MP.walkSpeed == nil then MP.walkSpeed = 4 end
		if MP.runSpeed == nil then MP.runSpeed = 8 end
		if MP.jumpSpeed == nil then MP.jumpSpeed = 24 end
		if MP.flySpeed == nil then MP.flySpeed = 16 end
		
	else
		--Meaning we need to access EXTRA parameters if we have them...
		if self.motionControls ~= nil then
		
		else
			self.motionControls = {};
		end
		
		if self.motionControls.airJumpProfile == nil then
			self.motionControls.airJumpProfile = {
				jumpSpeed = 34
				,jumpControlForce = 40
			}
		end
		if self.motionControls.airJumpProfile.jumpSpeed == nil then self.motionControls.airJumpProfile.jumpSpeed = 34; end
		if self.motionControls.airJumpProfile.jumpControlForce == nil then self.motionControls.airJumpProfile.jumpControlForce = 34; end
		
		if self.motionControls.liquidJumpProfile == nil then
			self.motionControls.liquidJumpProfile = {
				jumpSpeed = 4
				,jumpControlForce = 10
			}
		end
		if self.motionControls.liquidJumpProfile.jumpSpeed == nil then self.motionControls.liquidJumpProfile.jumpSpeed = 4; end
		if self.motionControls.liquidJumpProfile.jumpControlForce == nil then self.motionControls.liquidJumpProfile.jumpControlForce = 10; end
		
		if self.motionControls.walkSpeed == nil then self.motionControls.walkSpeed = 4 end
		if self.motionControls.runSpeed == nil then self.motionControls.runSpeed = 8 end
		if self.motionControls.flySpeed == nil then self.motionControls.flySpeed = 16 end
		
		--sb.logInfo( "RESET MOTION CONTROLS" );
		
		--MP = sb.jsonMerge( MP, self.motionControls );
		for k, v in pairs( self.motionControls ) do
			MP[k] = v;
		end
	end
	
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
	end
	vsoFacePoint( mcontroller.position()[1] + dir )
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

--function mMotionParameters()
	--self.options is NOT motion parameters! it's the pathfinding parameters.
	--if self.options ~= nil then 
	--	if self.options.movementParameters ~= nil then
	--		return self.options.movementParameters
	--	else
	--		return mParams();
	--	end
	--else
	--return mParams();
	--end
--end

function mMotionParametersSet( dats )
	if mcontroller.controlModifiers ~= nil then
		mcontroller.controlModifiers( dats )	--Actor
	else
		mcontroller.applyParameters( dats );	--Vehicle (not all parameters stick? odd... Mainly because SOME parameters are Actor only?
			
		if self.motionControls ~= {} then ; else self.motionControls = {}; end
		
		--HOWEVER we DO store (some) values in motionControls for vehicles.
		for k,v in pairs( dats ) do
			self.motionControls[ k ] = v;
		end
		
		
		--NOTE we need to track these extra parameters if we can...
		
		--local someshit = mParams();	--mcontroller.parameters()
		--[[
		local useem = ;
		
		{
			airFriction = 0
			,liquidFriction = 0.2
			,liquidImpedance = 0
			,groundFriction = 40
			,groundForce = 400
			--walkSpeed
			--runSpeed
			--jumpSpeed
			--flySpeed
			--jumpControlForce
		}
		]]--
		
		--if someshit.airFriction ~= nil then useem.airFriction = someshit.airFriction end
		--if someshit.liquidFriction ~= nil then useem.liquidFriction = someshit.liquidFriction end
		--if someshit.liquidImpedance ~= nil then useem.liquidImpedance = someshit.liquidImpedance end
		--if someshit.groundFriction ~= nil then useem.groundFriction = someshit.groundFriction end
		--if someshit.groundForce ~= nil then useem.groundForce = someshit.groundForce end
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
		self.motionControls.jump = true;
		self.motionControls.jumphold = false;
		--self.motionControls.jumpForce = mParams().airJumpProfile.jumpSpeed	--CAREFUL need to detect water... liquidJumpProfile
		
		--self.motionControls.jumpforce = mParams().airJumpProfile.jumpControlForce
		--jumpSpeed
        --mControlApproachYVel( velocity[2], mParams().airJumpProfile.jumpControlForce )
	end
end

function mControlJumpHold()
	if mcontroller.controlHoldJump ~= nil then
		mcontroller.controlHoldJump();
	else
		--Hmmmm
		self.motionControls.jumphold = true;
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
