oldInit = init
oldUpdate = update

stopWatch 	= 0

fed 		= false

head		= nil
chest		= nil
legs		= nil
back		= nil

fullhead	= nil
fullchest	= nil
fulllegs	= nil
fullback	= nil

victim		= nil

function init()
	oldInit()
	
	initHook()
--	local person = personalityType()		if we want to use a special fed personality
	
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

	local coast = world.entityQuery( mcontroller.position(), 16, {
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	local people = world.entityQuery( mcontroller.position(), 7, {
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	local personalspace = world.entityQuery( mcontroller.position(), 1, {
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	if #coast == 2 and #people == 2 and #personalspace == 1 then
		
		if people[1] == entity.id() then
			victim = people[2]
		else
			victim = people[1]
		end
		
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( victim ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			return
		end
		
		world.spawnProjectile( "npcvoreprojectile" , world.entityPosition( victim ))
		gain()
		fed = true
		feedHook()
	end
end

function digest()
	
	if stopWatch > 5000 then
		fed = false
		stopWatch = 0
		lose()
		
		digestHook()
	end
	
end

function gain()

	if fullhead then
		entity.setItemSlot( "head", fullhead )
	end
	
	if fullchest then
		entity.setItemSlot( "chest", fullchest )
	end
	
	if fulllegs then
		entity.setItemSlot( "legs", fulllegs )
	end
	
	if fullback then
		entity.setItemSlot( "back", fullback )
	end
	
	gainHook()
end

function lose()

	if head then
	entity.setItemSlot( "head", head )
	end
	
	if chest then
	entity.setItemSlot( "chest", chest )
	end
	
	if legs then
	entity.setItemSlot( "legs", legs )
	end
	
	if back then
	entity.setItemSlot( "back", back )
	end
	
	loseHook()
end

function update(dt)
	tempUpdate = update
	oldUpdate(dt)
	
	if not fed and math.random(850) == 1 then
		feed()
	elseif fed then
		stopWatch = stopWatch + 1
		digest()
	end
	
	updateHook()
	
	update = tempUpdate
end

function initHook()

end

function feedHook()

end

function digestHook()

end

function gainHook()

end

function loseHook()

end

function updateHook()

end