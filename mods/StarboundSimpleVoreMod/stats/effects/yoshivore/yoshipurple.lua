require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

request = false
singleton = true
stopWatch = 0

function init()

	if effect.duration() >= 20000 then
		status.addPersistentEffects( "requestvore", {"intents", "nofalldamage", "paralysis"} )
		request = true
		effect.modifyDuration(-20000)
	else
		status.addEphemeralEffect("intents", 60.0)
		status.addEphemeralEffect("nofalldamage", 60.0)
		status.addEphemeralEffect("paralysis", 60.0)
	end

	if world.entityExists(effect.duration()) then
		pred = effect.duration()
		effect.modifyDuration(60 - effect.duration())
	else
		request = true
		uninit()
	end	
	
end

function update(dt)
	
	if world.entityExists( pred ) then
		vector = world.entityPosition( pred )
	else
		uninit()
	end
	
	if vector ~= nil then
		mcontroller.setPosition( vector )
	else
		uninit()
	end
	
	if effect.duration() <= 60 and request then
		effect.modifyDuration(1)
	end
	
	if stopWatch <= 60 then
		stopWatch = stopWatch + dt
	end
	
end

function uninit()

	if singleton then
		status.clearPersistentEffects("requestvore")
		status.removeEphemeralEffect("intents")
		status.removeEphemeralEffect("nofalldamage")
		status.removeEphemeralEffect("paralysis")
		effect.modifyDuration(-effect.duration())
	
		if stopWatch >= 60 then
			world.spawnProjectile( "yoshipurpleegg" , vec2.add( world.entityPosition( entity.id() ), {0,-1.1}) )
			status.addEphemeralEffect("intents", 60.0)
			status.addEphemeralEffect("nofalldamage", 60.0)
			status.addEphemeralEffect("paralysis", 60.0)
		end
		singleton = false
	end
end