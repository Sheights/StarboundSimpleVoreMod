require "/scripts/behavior.lua"
require "/scripts/actions/math.lua"
require "/scripts/actions/position.lua"
require "/scripts/actions/movement.lua"
require "/scripts/actions/time.lua"
require "/scripts/actions/status.lua"
require "/scripts/actions/notification.lua"

function init()
	people = world.entityQuery( mcontroller.position(), 7, {
			includedTypes = {"player", "npc"},
			boundMode = "CollisionArea"
	})
	
	if people[1] == entity.id() then
		pred = people[2]
	else
		pred = people[1]
	end
end

function update(dt)
	mcontroller.setPosition( world.entityPosition(pred))
end

function uninit()
--	world.sendEntityMessage("letgo")
end