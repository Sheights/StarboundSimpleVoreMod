require "/scripts/vec2.lua"

function init()

	status.addPersistentEffects( "egg", {"intents", "paralysis"} )
	animator.setAnimationState( "objectState", "default" )
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
	effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})

	self.healingRate = 1.0 / 180

	base = mcontroller.position()
	state = 1
	timer = 0
	groundLock = 0

--	effect.addStatModifierGroup({
--  {stat = "jumpModifier", amount = -0.8}
--	})

end

function update(dt)
	
--	mcontroller.controlModifiers({
--      airJumpModifier = 0.20
--    })
	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
			status.clearPersistentEffects("egg")
		end
	end
	
	if mcontroller.onGround() then
		if groundLock == 0 then
			groundLock = 1
			base = mcontroller.position()
		end
		if timer > 10 then
			animState = animator.animationState("objectState")
			
			if animState == "default" then
				animator.setAnimationState("objectState", "ready" )
			end
			
			if mcontroller.onGround() then
		
				animState = animator.animationState("objectState")
				if status.resourcePercentage("health") > state * 0.24 then
					if mcontroller.xVelocity() > 0 and atRest() then
						if state > 3 then
							status.clearPersistentEffects("egg")
							effect.expire()
							do return end
						end

						animator.setAnimationState("objectState", "right" .. state )
					
						state = state + 1
					elseif mcontroller.xVelocity() < 0 and atRest() then
						if state > 3 then
							status.clearPersistentEffects("egg")
							effect.expire()
							do return end
						end

						animator.setAnimationState("objectState", "left" .. state )
					
						state = state + 1
					end
				end
				mcontroller.setXVelocity( 0 )
			end
		else
			timer = timer + dt
			if timer > 10 then
				status.setPersistentEffects( "egg", {"intents"} )
			end
		end
		mcontroller.setPosition( base )
	else
		groundLock = 0
	end
	status.modifyResourcePercentage("health", self.healingRate * dt)
end

function uninit()
	local effects = status.getPersistentEffects("egg")
	if #effects > 0 then
		status.setPersistentEffects( "egg", {"intents", "paralysis"} )
	end
end

function atRest()
	if animState == "ready" or animState == "idle1" or animState == "idle2" or animState == "idle3" then
		do return true end
	end
	do return false end
end