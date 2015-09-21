local oldInit = init
local oldUpdate = update

function init()
	oldInit()
	
	world.logInfo( "I am alive" )
	local fed = false
--	local person = personalityType()		if we want to use a special fed personality
	local victim = nil
	
	message.setHandler("eaten", function(_, _, params)
		fed = true
--		entity.setItemSlot( "chest", "wolfcostumebelly")
--		setPersonality("fed")
	end)
	
	message.setHandler("letgo", function(_, _, params)
		fed = false
		victim = nil
--		entity.setItemSlot( "chest", "wolfcostumebelly")
--		setPersonality("person")
	end)
end

function search()

--	local people = world.entityQuery( entity.toAbsolutePosition({ 0, 0 }), 20, {
--     includedTypes = {"npc"},
--     boundMode = "CollisionArea"
 --   })
	
--	if #people == 2 then
--		world.logInfo( " has found someone to eat." )
		
--		if people[1] == entity.id() then
--			victim = people[2]
--		else
--			victim = people[1]
--		end
--		world.spawnProjectile( "npcvoreprojectile" , world.entityPosition( victim ), entity.id(), { 0, 0 }, false )
--		world.logInfo( " has attempted to eat "  )
		entity.setItemSlot( "chest", wolfbellychest )
		entity.setItemSlot( "legs", wolfbellylegs )
--		chest = entity.getItemSlot( "chest" )
--		legs = entity.getItemSlot( "legs" )
		
--		world.logInfo( tostring(chest) )
--		world.logInfo( tostring(legs) )
--		fed = true
--	end
end

function update(dt)
	oldUpdate(dt)
	
	if not fed then
		search()
	end
end