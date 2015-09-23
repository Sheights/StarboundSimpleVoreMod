local oldInit = init
local oldUpdate = update
local stopWatch = 0
local fed = false
local victim = nil

function init()
	oldInit()

--	local person = personalityType()		if we want to use a special fed personality
	
	entity.setItemSlot( "head", "wolfcostumehead" )
	entity.setItemSlot( "chest", "wolfcostumechest" )
	entity.setItemSlot( "legs", "wolfcostumelegs" )
	
--	message.setHandler("eaten", function(_, _, params)
--		fed = true
--		entity.setItemSlot( "chest", "wolfcostumebelly")
--		setPersonality("fed")
--	end)
	
--	message.setHandler("letgo", function(_, _, params)
--		fed = false
--		victim = nil
--		entity.setItemSlot( "chest", "wolfcostumebelly")
--		setPersonality("person")
--	end)
end

function feed()
	people = world.entityQuery( mcontroller.position(), 10, {
		includedTypes = {"npc"},
		boundMode = "CollisionArea"
	})
	
	if #people == 2 then
		
		if people[1] == entity.id() then
			victim = people[2]
		else
			victim = people[1]
		end
		
		world.spawnProjectile( "npcvoreprojectile" , world.entityPosition( victim ), entity.id(), { 0, 0 }, false )
		
		entity.setItemSlot( "chest", "wolfbellychest" )
		entity.setItemSlot( "legs", "wolfbellylegs" )

		fed = true
	end
end

function digest()
	
	if stopWatch > 50 then
		entity.setItemSlot( "chest", "wolfcostumechest" )
		entity.setItemSlot( "legs", "wolfcostumelegs" )
		fed = false
		stopWatch = 0
	end
	
end

function update(dt)
	tempUpdate = update
	oldUpdate(dt)

	
	if not fed and math.random(1000) == 1 then
		feed()
	elseif fed then
		stopWatch = stopWatch + 1
		digest()
	end
	
	update = tempUpdate
end