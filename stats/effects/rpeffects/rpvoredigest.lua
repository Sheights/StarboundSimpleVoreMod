function init()

	status.clearPersistentEffects("rpvore")
	status.clearPersistentEffects("rpvoreheal")
	
	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "rpvoredigest", {"intents", "nofalldamage", "paralysis", "savor"} )

end

function update(dt)
	
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
		status.clearPersistentEffects("rpvoredigest")
		effect.expire()
		do return end
	end
	
	if pred == entity.id() then
		status.clearPersistentEffects("rpvoredigest")
		effect.expire()
		do return end
	end

	if vector ~= nil then
		if blink then
			mcontroller.setPosition( vector )
		end
	else
		status.clearPersistentEffects("rpvoredigest")
		effect.expire()
		do return end
	end

	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
			status.clearPersistentEffects("rpvoredigest")
		end
	end

	local effects = status.getPersistentEffects("rpvoredigest")

	if #effects == 0 then
		status.clearPersistentEffects("rpvoredigest")
		effect.expire()
		do return end
	end
	blink = true

end

function uninit()

	effect.expire()

end