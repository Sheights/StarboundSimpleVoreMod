require "/scripts/behavior.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/time.lua"
require "/scripts/actions/status.lua"
require "/scripts/actions/notification.lua"

function init()

	if world.entityExists(effect.duration()) then
		pred = effect.duration()
		effect.modifyDuration(90 - effect.duration())
	else
		people = world.entityQuery( mcontroller.position(), 2, {
			withoutEntityId = entity.id(),
			includedTypes = {"player", "npc"},
			boundMode = "CollisionArea",
		})
		pred = people[1]	
	end	
end

function update(dt)
	if pred ~= nil then
		mcontroller.setPosition( world.entityPosition(pred))
	end
end

function uninit()

end