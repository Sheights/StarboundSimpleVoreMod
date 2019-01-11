require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

function init()
	
	if effect.duration() >= 10000 then
		status.addEphemeralEffect("npcacid", 90.0)		
		effect.modifyDuration(-10000)
	end
	
	pred = effect.duration()
	
	status.addEphemeralEffect("intents", 90.0)
	status.addEphemeralEffect("nofalldamage", 90.0)
	status.addEphemeralEffect("paralysis", 90.0)


	if not world.entityExists( pred ) then
		earlyExit()	
	end

	vector = world.entityPosition( pred )
	effect.modifyDuration(90 - effect.duration())

end

function update(dt)

	if vector ~= null and world.entityExists ( pred )then
		mcontroller.setPosition( vector )
	else
		earlyExit()
	end
	
end

function earlyExit()

	status.removeEphemeralEffect("intents")
	status.removeEphemeralEffect("nofalldamage")
	status.removeEphemeralEffect("npcacid")
	status.removeEphemeralEffect("paralysis")
	effect.expire()
	
end