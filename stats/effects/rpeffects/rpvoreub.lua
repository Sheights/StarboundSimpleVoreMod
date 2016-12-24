function init()

	status.clearPersistentEffects("vore")
	
	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "vore", {"intents", "nofalldamage", "paralysis"} )

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

end

function uninit()

	effect.expire()

end