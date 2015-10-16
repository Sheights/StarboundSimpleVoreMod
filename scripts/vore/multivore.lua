oldInit = init
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
stopWatch	= { 0, 0, 0 }

occupency	= 0
capacity	= 3

i 			= 0
j			= 0

isDigest	= false
isPlayer	= false

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

victim		= { nil, nil, nil }

projectile	= "npcvoreprojectile"
dprojectile	= "npcdvoreprojectile"

function init()
	oldInit()
	
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
	
	
	if #people == occupency + 1 and #eggcheck == occupency + 1 and #personalspace == occupency then
		
--		First Victim
		if #victim == 0 then
			victim[1] = people[1]
--		Second and third Victims
		else
			for i=1, #people do
				j = 1
				while (j <= #victim) do	
					if people[i] == victim[j] then
						break
					end
					j = j+1
				end
				if j == #victim+1 then
					temp = i
				end
			end
			victim[occupency+1] = people[temp]
		end
		
		if world.isNpc( victim[occupency+1] ) == false then
			isPlayer = true
		end
		
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( victim[occupency+1] ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			return
		end
		
		if ( isPlayer and math.random() <= playerChance ) or isPlayer == false then
		
			local mergeOptions = {
				statusEffects = {
				{
						effect = "dragonvore",
						duration = entity.id()
			}}}
			
			if isDigest then
				world.spawnProjectile( dprojectile , world.entityPosition( victim[occupency+1] ), entity.id(), {0, 0}, false, mergeOptions)
			else
				world.spawnProjectile( projectile , world.entityPosition( victim[occupency+1] ), entity.id(), {0, 0}, false, mergeOptions)
			end
			occupency = occupency + 1
			redress()
			
			feedHook()
			
			if isPlayer then
				playerTimer = 0
			end
			
		else
			victim [occupency + 1] = nil
		end
		isPlayer = false	
	end
end

function digest()

	if stopWatch[1] >= duration then
		occupency = occupency - 1
		redress()
		stopWatch[1] = stopWatch[2]
		stopWatch[2] = stopWatch[3]
		stopWatch[3] = nil
		
		victim [1] = victim [2]
		victim [2] = victim [3]
		victim [3] = nil
		digestHook()
	end
	
end

function redress()

	if occupency == 0 then
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
	elseif occupency == 1 or occupency == 2 then
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
	tempUpdate = update
	oldUpdate(dt)
	
	if occupency < capacity and math.random(750) == 1 then
		feed()
	end
	
	if occupency > 0 then
		i = 1
		while stopWatch[i] do
			stopWatch[i] = stopWatch[i] + dt
			i = i + 1
		end
		if playerTimer <= duration then
			playerTimer = playerTimer + dt
		end
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

function dressHook()

end

function updateHook()

end