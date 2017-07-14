
function init()

	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "vore", {"intents", "paralysis" } )
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
	self.digestRate = -(1.0 / 120)
end

function update(dt)
	
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end

	if vector ~= nil then
		if blink then
			mcontroller.setPosition( vector )
		end
	else
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end

	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
			status.clearPersistentEffects("vore")
		end
	end

	local effects = status.getPersistentEffects("vore")

	if #effects == 0 then
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end
	blink = true
	
	if status.resourcePercentage("health") > 0.02 then
		status.modifyResourcePercentage("health", self.digestRate * dt)
	end

end

function uninit()
	local effects = status.getPersistentEffects("vore")
	if #effects == 0 then
		status.clearPersistentEffects("vore")
	end
	effect.expire()

end