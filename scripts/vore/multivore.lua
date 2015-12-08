oldInit = init
oldInteract = interact
oldUpdate = update

---------------------------------------------------------------------------------------
--#####################################################################################
--CONFIG SECTION

-- Player Chance is a percent chance that the player will be vored compared to the standard base chance
-- Keep the value anywhere between 0 and 1
-- 0% = 0, 50% = 0.5 or 1/2, 100% chance = 1.0
-- This can also be done in the individual .lua files.
playerChance = 0.5

--#####################################################################################
---------------------------------------------------------------------------------------
duration 	= 120
playerTimer = 120
talkTimer	= 1
stopWatch	= { 0, 0, 0 }

capacity	= 3

i 			= 0
j			= 0

isDigest	= false
isPlayer	= false
requested	= false

head		= nil
chest		= nil
legs		= nil
back		= nil

midhead		= nil
midchest	= nil
midlegs		= nil
midback		= nil

fullhead	= nil
fullchest	= nil
fulllegs	= nil
fullback	= nil

request		= { false, false, false }
victim		= { nil, nil, nil }

voreeffect = "dragonvore"
projectile	= "npcvoreprojectile"
dprojectile	= "npcdvoreprojectile"

function init()
	oldInit()
	
	entity.setInteractive(true)
	
	initHook()
end

function feed()
	
	local people = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	local eggcheck = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player", "projectile"},
		boundMode = "CollisionArea"
	})
	
	local personalspace = world.entityQuery( mcontroller.position(), 2, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	
	if #people == #victim + 1 and #eggcheck == #victim + 1 and #personalspace == #victim then
		
		i = 1
		temp = 1
		
--		First Victim
		if #victim == 0 then
			victim[1] = world.entityName(people[temp])
--		Second and third Victims
		else			
			for i=1, #people do
				j = 1
				while (j <= #victim) do	
					if world.entityName(people[i]) == victim[j] then
						break
					end
					j = j+1
				end
				if j == #victim+1 then
					temp = i
				end
			end
			victim[#victim+1] = world.entityName(people[temp])
		end
		
		
		
		if world.isNpc( people[temp] ) == false then
			isPlayer = true
		end
				
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( people[temp] ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			return
		end
		
		if ( isPlayer and math.random() <= playerChance ) or isPlayer == false or requested then
		
			tem = entity.id()
			
			if requested then
				tem = tem + 20000
				request[#victim] = true
			end
			
			if isDigest then
				tem = tem + 10000
			end
			
			local mergeOptions = {
				statusEffects = {
				{
					effect = voreeffect,
					duration = tem
			}}}
			
			world.spawnProjectile( projectile , world.entityPosition( people[temp] ), entity.id(), {0, 0}, false, mergeOptions)
	
			redress()
			feedHook()
			
			if isPlayer and requested == false then
				playerTimer = 0
			end
			
		else
			victim[#victim] = nil
		end
	end
	isPlayer = false
	requested = false
end

function digest()

	if stopWatch[1] >= duration and request[1] == false then
		
		stopWatch[1] = stopWatch[2]
		stopWatch[2] = stopWatch[3]
		stopWatch[3] = 0
		
		victim [1] = victim [2]
		victim [2] = victim [3]
		victim [3] = nil
		
		request [1] = request [2]
		request [2] = request [3]
		request [3] = false
		redress()

		digestHook()
	elseif stopWatch[2] >= duration and request[2] == false then
		
		stopWatch[2] = stopWatch[3]
		stopWatch[3] = 0
				
		victim [2] = victim [3]
		victim [3] = nil
		
		request [2] = request [3]
		request [3] = false
		
		redress()

		digestHook()
	elseif stopWatch[3] >= duration and request[3] == false then
		
		stopWatch[3] = 0
		victim [3] = nil
		request [3] = false
		
		redress()

		digestHook()
	end
	
end

function redress()

	if #victim == 0 then
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
	elseif #victim == 1 or #victim == 2 then
		if midhead then
			entity.setItemSlot( "head", midhead )
		end
		if midchest then
			entity.setItemSlot( "chest", midchest )
		end
		if midlegs then
			entity.setItemSlot( "legs", midlegs )
		end
		if midback then
			entity.setItemSlot( "back", midback )
		end
	else
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
	end
	
	dressHook()
end

function update(dt)
	tempupdate = update
	tempinteract = interact
	oldUpdate(dt)
	
	if #victim < capacity and math.random(750) == 1 then
		feed()
	end
	
	if #victim > 0 then
		i = 1
		for i=1, #victim do
			stopWatch[i] = stopWatch[i] + dt
		end
		if playerTimer <= duration then
			playerTimer = playerTimer + dt
		end
		digest()
	end
	
	if talkTimer < 1 then
		talkTimer = talkTimer + dt
	end
	
	updateHook()
	
	update = tempupdate
	interact = tempinteract
end

function interact(args)
	
	if talkTimer < 1 then
	
		if isVictim( world.entityName( args.sourceId ) ) then
		
			world.spawnProjectile( "cleanser" , world.entityPosition( entity.id() ), entity.id(), {0, 0}, true )
			
			playerTimer = 120
			request[1] = false
			request[2] = false
			request[3] = false
			stopWatch[1] = 0
			stopWatch[2] = 0
			stopWatch[3] = 0
			victim[1] = nil
			victim[2] = nil
			victim[3] = nil
			redress()
		else
			requested = true
			feed()
		end
		
		talkTimer = 1
		
	else
		talkTimer = 0
	end

	interactHook()
	oldInteract(args)

	return nil

end

function isVictim( name )

	local personalspace = world.entityQuery( mcontroller.position(), 2, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	for i=1, #personalspace do
		if world.entityName( personalspace[i] ) == name then
			return true
		end
	end
	
	return false
	
end

function initHook()

end

function feedHook()

end

function digestHook()

end

function dressHook()

end

function updateHook()

end

function interactHook()

end