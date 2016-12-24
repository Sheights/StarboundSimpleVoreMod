function init()

	status.clearPersistentEffects("rpvore")
	status.clearPersistentEffects("rpvoredigest")
	
	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "rpvoreheal", {"intents", "nofalldamage", "paralysis", "voreheal"} )

end

function update(dt)
	
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
		status.clearPersistentEffects("rpvoreheal")
		effect.expire()
		do return end
	end
	
	if pred == entity.id() then
		status.clearPersistentEffects("rpvoreheal")
		effect.expire()
		do return end
	end

	if vector ~= nil then
		if blink then
			mcontroller.setPosition( vector )
		end
	else
		status.clearPersistentEffects("rpvoreheal")
		effect.expire()
		do return end
	end

	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
			status.clearPersistentEffects("rpvoreheal")
		end
	end

	local effects = status.getPersistentEffects("rpvoreheal")

	if #effects == 0 then
		status.clearPersistentEffects("rpvoreheal")
		effect.expire()
		do return end
	end
	blink = true

end

function uninit()

	effect.expire()

end