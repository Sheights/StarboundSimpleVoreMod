require "/scripts/vec2.lua"

function init()

	status.clearPersistentEffects("rpvore")
	status.clearPersistentEffects("rpvoredigest")
	status.clearPersistentEffects("rpvoreheal")

	status.addPersistentEffects( "egg", {"intents"} )
	status.addPersistentEffects( "para", {"paralysis"} )
	animator.setAnimationState( "objectState", "default" )
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
	
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
				mcontroller.setXVelocity( 0 )
			end
		else
			timer = timer + dt
			if timer > 10 then
				status.clearPersistentEffects("para")
			end
		end
		mcontroller.setPosition( base )
	else
		groundLock = 0
	end
end

function uninit()
	effect.expire()
end

function atRest()
	if animState == "ready" or animState == "idle1" or animState == "idle2" or animState == "idle3" then
		do return true end
	end
	do return false end
end