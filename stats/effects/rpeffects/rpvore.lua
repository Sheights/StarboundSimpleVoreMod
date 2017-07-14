require "/scripts/vec2.lua"

function init()

	status.clearPersistentEffects("rpvoredigest")
	status.clearPersistentEffects("rpvoreheal")

	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "rpvore", {"intents", "paralysis"} )
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})

end

function update(dt)
	
	if pred ~= nil then
		if world.entityExists( pred ) then
			vector = world.entityPosition( pred )
		else
			status.clearPersistentEffects("rpvore")
			effect.expire()
			do return end
		end
	end
	
	if pred == entity.id() then
		status.clearPersistentEffects("rpvore")
		effect.expire()
		do return end
	end
	
	if vector ~= nil then
		if blink then
			mcontroller.setPosition( vector )
		end
	else
		status.clearPersistentEffects("rpvore")
		effect.expire()
		do return end
	end
	
	
	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
			status.clearPersistentEffects("rpvore")
		end
	end
	
	
	local effects = status.getPersistentEffects("rpvore")

	if #effects == 0 then
		status.clearPersistentEffects("rpvore")
		effect.expire()
		do return end
	end
	blink = true

end

function uninit()

end