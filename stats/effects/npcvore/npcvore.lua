require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

request = false

function init()

	if effect.duration() >= 30000 then
		status.addPersistentEffects( "requestvore", {"intents", "nofalldamage", "npcacid", "paralysis"} )
		request = true
		effect.modifyDuration(-30000)
	elseif effect.duration() >= 20000 then
		status.addPersistentEffects( "requestvore", {"intents", "nofalldamage", "paralysis"} )
		request = true
		effect.modifyDuration(-20000)
	elseif effect.duration() >= 10000 then
		status.addEphemeralEffect("intents", 90.0)
		status.addEphemeralEffect("nofalldamage", 90.0)
		status.addEphemeralEffect("npcacid", 90.0)
		status.addEphemeralEffect("paralysis", 90.0)		
		effect.modifyDuration(-10000)
	else
		status.addEphemeralEffect("intents", 90.0)
		status.addEphemeralEffect("nofalldamage", 90.0)
		status.addEphemeralEffect("paralysis", 90.0)
	end

	if world.entityExists(effect.duration()) then
		pred = effect.duration()
		effect.modifyDuration(90 - effect.duration())
	else
		request = true
		uninit()
	end	
	
end

function update(dt)
	
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
		request = true
		uninit()
	end
	
	if vector ~= nil then
		mcontroller.setPosition( vector )
	else
		request = true
		uninit()
	end
	
	if effect.duration() <= 90 and request then
		effect.modifyDuration(1)
	end
	
end

function uninit()

	if request then
		status.clearPersistentEffects("requestvore")
		status.removeEphemeralEffect("intents")
		status.removeEphemeralEffect("nofalldamage")
		status.removeEphemeralEffect("npcacid")
		status.removeEphemeralEffect("paralysis")
		effect.modifyDuration(-effect.duration())
	end
	
end