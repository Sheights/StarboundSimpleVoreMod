require "/scripts/vec2.lua"

function vsoinit()

	message.setHandler("vsoForceApply", function( _, _, x, y, xmode, ymode )
		if xmode > 0 then
			if xmode == 1 then
				mcontroller.setXVelocity( mcontroller.xVelocity() + x )
			elseif xmode == 2 then
				mcontroller.setXVelocity( x)
			elseif xmode == 3 then
				mcontroller.force( { x,0 } )
			elseif xmode == 4 then
				--mcontroller.approachXVelocity( x, float maxControlForce)
			elseif xmode == 5 then
				--mcontroller.addMomentum
			end
		end
		if ymode > 0 then
			if ymode == 1 then
				mcontroller.setYVelocity( mcontroller.yVelocity() + y )
			elseif ymode == 2 then
				mcontroller.setYVelocity( y )
			elseif ymode == 3 then
				mcontroller.force( { 0,y } )
			elseif ymode == 4 then
				--mcontroller.approachXVelocity( x, float maxControlForce)
			elseif ymode == 5 then
				--mcontroller.addMomentum
			end
		end
	end )

	--message.setHandler( "vsoChangeDamageTeam", function( _, _, value )
	--	--Hm...
	--	--return monster.setDamageTeam( value )
	--end )
	
	message.setHandler( "vsoStatusPropertySet", function( _, _, prop, value )
		return status.setStatusProperty( prop, value )
	end )
	
	message.setHandler( "vsoStatusPropertyGet", function( _, _, prop, defaultvalue )
		return status.statusProperty( prop, defaultvalue )
	end )
	
	message.setHandler( "vsoResourceGetSummary", function( _, _ )
		local R = {}
		for i,k in pairs( status.resourceNames() ) do
			R[k] = {
				status.resource(k)	--isResource
				,status.resourceMax(k)
				,status.resourcePercentage(k)
				,status.resourcePositive(k)
				,status.resourceLocked(k)
			}
		end
		return R;
	end )
	
	message.setHandler( "vsoResourceAddPercent", function( _, _, resname, deltapercent, resthresh )

		if resthresh ~= nil then
			local epsilon = 1;
			local retval = true;
			local resthreshreal = resthresh*status.resourceMax( resname );
			local currval = status.resource( resname );
			local deltaval = deltapercent*status.resourceMax( resname );
			local nextval = currval + deltaval
			if deltapercent < 0 then
				if nextval <= resthreshreal+epsilon then
					status.setResource( resname, resthreshreal+epsilon )
					retval = false;
				else
					status.modifyResource( resname, deltaval )
				end
			elseif deltapercent > 0 then
				if nextval >= resthreshreal-epsilon then
					status.setResource( resname, resthreshreal-epsilon )
					retval = false;
				else
					status.modifyResource( resname, deltaval )
				end
			end
			return retval;
		else
	
			if deltapercent < 0 then
				status.overConsumeResource( resname, -deltapercent*status.resourceMax( resname ) )
			else
				status.modifyResourcePercentage( resname, deltapercent );
			end
			return status.resource( resname ) > 0;
		end
	end )

	
end

--CAREFUL! we have to update this each time and it may be dangerous to replace the monster_stat handling!
--Also it's hard to mod every monster to handle this so...
--Some mods like frackin' remap it to a different handler.

function init()
  self.damageFlashTime = 0
	vsoinit();
  message.setHandler("applyStatusEffect", function(_, _, effectConfig, duration, sourceEntityId)
      status.addEphemeralEffect(effectConfig, duration, sourceEntityId)
    end)
end

function applyDamageRequest(damageRequest)
  if world.getProperty("nonCombat") then
    return {}
  end

  local damage = 0
  if damageRequest.damageType == "Damage" or damageRequest.damageType == "Knockback" then
    damage = damage + root.evalFunction2("protection", damageRequest.damage, status.stat("protection"))
  elseif damageRequest.damageType == "IgnoresDef" then
    damage = damage + damageRequest.damage
  elseif damageRequest.damageType == "Environment" then
    return {}
  end

  if status.resourcePositive("shieldHealth") then
    local shieldAbsorb = math.min(damage, status.resource("shieldHealth"))
    status.modifyResource("shieldHealth", -shieldAbsorb)
    damage = damage - shieldAbsorb
  end

  local hitType = damageRequest.hitType
  local elementalStat = root.elementalResistance(damageRequest.damageSourceKind)
  local resistance = status.stat(elementalStat)
  damage = damage - (resistance * damage)
  if resistance ~= 0 and damage > 0 then
    hitType = resistance > 0 and "weakhit" or "stronghit"
  end

  local healthLost = math.min(damage, status.resource("health"))
  if healthLost > 0 and damageRequest.damageType ~= "Knockback" then
    status.modifyResource("health", -healthLost)
    if hitType == "stronghit" then
      self.damageFlashTime = 0.07
      self.damageFlashType = "strong"
    elseif hitType == "weakhit" then
      self.damageFlashTime = 0.07
      self.damageFlashType = "weak"
    else
      self.damageFlashTime = 0.07
      self.damageFlashType = "default"
    end
  end

  status.addEphemeralEffects(damageRequest.statusEffects, damageRequest.sourceEntityId)

  local knockbackFactor = (1 - status.stat("grit"))
  local momentum = knockbackMomentum(vec2.mul(damageRequest.knockbackMomentum, knockbackFactor))
  if status.resourcePositive("health") and vec2.mag(momentum) > 0 then
    self.applyKnockback = momentum
    if vec2.mag(momentum) > status.stat("knockbackThreshold") then
      status.setResource("stunned", math.max(status.resource("stunned"), status.stat("knockbackStunTime")))
    end
  end

  if not status.resourcePositive("health") then
    hitType = "kill"
  end
  return {{
    sourceEntityId = damageRequest.sourceEntityId,
    targetEntityId = entity.id(),
    position = mcontroller.position(),
    damageDealt = damage,
    healthLost = healthLost,
    hitType = hitType,
    kind = "Normal",
    damageSourceKind = damageRequest.damageSourceKind,
    targetMaterialKind = status.statusProperty("targetMaterialKind")
  }}
end

function knockbackMomentum(momentum)
  local knockback = vec2.mag(momentum)
  if mcontroller.baseParameters().gravityEnabled and math.abs(momentum[1]) > 0  then
    local dir = momentum[1] > 0 and 1 or -1
    return {dir * knockback / 1.41, knockback / 1.41}
  else
    return momentum
  end
end

function update(dt)
  if self.damageFlashTime > 0 then
    local color = status.statusProperty("damageFlashColor") or "ff0000=0.85"
    if self.damageFlashType == "strong" then
      color = status.statusProperty("strongDamageFlashColor") or "ffffff=1.0" or color
    elseif self.damageFlashType == "weak" then
      color = status.statusProperty("weakDamageFlashColor") or "000000=0.0" or color
    end
    status.setPrimaryDirectives(string.format("fade=%s", color))
  else
    status.setPrimaryDirectives()
  end
  self.damageFlashTime = math.max(0, self.damageFlashTime - dt)

  if self.applyKnockback then
    mcontroller.setVelocity({0,0})
    if vec2.mag(self.applyKnockback) > status.stat("knockbackThreshold") then
      mcontroller.addMomentum(self.applyKnockback)
    end
    self.applyKnockback = nil
  end

  if mcontroller.atWorldLimit(true) then
    status.setResourcePercentage("health", 0)
  end
end
