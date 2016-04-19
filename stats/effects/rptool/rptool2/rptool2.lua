require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

request = false

function init()

	local people = world.entityQuery( mcontroller.position(), 7, {
				withoutEntityId = entity.id(),
				includedTypes = {"player"},
				boundMode = "CollisionArea"
	})
	
	if #people == 1 then
		predator = people[1]
		status.addPersistentEffects( "voreEffects", {"intents", "nofalldamage", "paralysis"} )
	end
end

function update(dt)

		if predator ~= nil then
			vector = world.entityPosition( predator )
			mcontroller.setPosition( vector )
			if effect.duration() < 10 then
				effect.modifyDuration(10)
			end
		else
			effect.expire()
		end

end

function uninit()
	
	status.clearPersistentEffects("voreEffects")
	
end