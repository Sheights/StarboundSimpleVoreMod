local oldInit = init
local oldUpdate = update

local stopWatch = 0

local fed = false

local head = "wolfdeserthead"
local chest = "wolfdesertchest"
local legs = "wolfdesertlegs"
local fullhead = nil
local fullchest = "wolfdesertchestbelly"
local fulllegs = "wolfdesertlegsbelly"
local victim = nil

function init()
	oldInit()

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
	people = world.entityQuery( mcontroller.position(), 10, {
		includedTypes = {"npc"},
		boundMode = "CollisionArea"
	})
	
	personalspace = world.entityQuery( mcontroller.position(), 2, {
		includedTypes = {"npc"},
		boundMode = "CollisionArea"
	})
	
	if #people == 2 and personalspace == 1 then
		
		if people[1] == entity.id() then
			victim = people[2]
		else
			victim = people[1]
		end
		
		world.spawnProjectile( "npcvoreprojectile" , world.entityPosition( victim ), entity.id(), { 0, 0 }, false )
		gain()
		fed = true
	end
end

function digest()
	
	if stopWatch > 3000 then
		fed = false
		stopWatch = 0
		lose()
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