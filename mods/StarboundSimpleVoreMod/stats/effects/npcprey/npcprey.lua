require "/scripts/behavior.lua"
require "/scripts/vec2.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/notification.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/status.lua"

request = false

function init()
	if effect.duration() > 100 then
		status.addPersistentEffects( "voreEffects", {"intents", "npcpreyacid", "paralysis"} )
	else
		status.addPersistentEffects( "voreEffects", {"intents", "paralysis"} )
	end
	effect.addStatModifierGroup({{stat = "fallDamageMultiplier", effectiveMultiplier = 0}})
	local people = world.entityQuery( mcontroller.position(), 7, {
				includedTypes = {"player"},
				boundMode = "CollisionArea"
	})
	predator = people[1]
end

function update(dt)
		
		vector = world.entityPosition( predator )
		
		if vector ~= nil then
			mcontroller.setPosition( vector )
		else
			effect.expire()
		end
		
		if effect.duration() < 10 then
			effect.modifyDuration(10)
		end
		
		if math.random(500) == 1 then
--			world.spawnProjectile( digestsound , mcontroller.position(), entity.id(), {0, 0}, false )
		end
		
end

function uninit()
	
	status.clearPersistentEffects("voreEffects")
	
end