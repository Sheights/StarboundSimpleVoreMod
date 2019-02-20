function init()
	pred = effect.sourceEntity()
	blink = false
	status.addPersistentEffects( "vore", {"intents", "paralysis" } )
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
	effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})
end

function update(dt)
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
--		sb.logInfo("exited via pred missing")
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end

	if vector ~= nil then
		if blink then
			mcontroller.setPosition( vector )
		end
	else
--		sb.logInfo("exited via no vector")
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end

	if effect.duration() <= 90 then
		if effect.duration() > 1 then
			effect.modifyDuration(1)
		else
--			sb.logInfo("exited via low duration")
			status.clearPersistentEffects("vore")
			effect.expire()
			do return end
		end
	end

	local effects = status.getPersistentEffects("vore")

	if #effects == 0 then
--		sb.logInfo("exited via no effects")
		status.clearPersistentEffects("vore")
		effect.expire()
		do return end
	end
	
	if blink then	--fix added for a real problem that should be tracked down. somehow the eaten thing targets ITSELF.
		if pred == entity.id() then
			status.clearPersistentEffects("vore")
			effect.expire()
			do return end
		end
	end
	
	blink = true
end


function uninit()
--	sb.logInfo("digest ending")
end