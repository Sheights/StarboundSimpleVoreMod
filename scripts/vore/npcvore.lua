oldInit = init
--oldInteract = interact
oldUpdate = update

---------------------------------------------------------------------------------------
--#####################################################################################
--CONFIG SECTION

-- Player Chance is a percent chance that the player will be vored compared to the standard base chance
-- Keep the value anywhere between 0 and 1
-- 0% = 0, 50% = 0.5 or 1/2, 100% chance = 1.0
-- This can also be done in the individual .lua files.
playerChance = 0.5

-- NPC Chance is a percent chance that an NPC will be vored when the feed function is called.
-- Keep the value anywhere between 0 and 1
-- 0% = 0, 50% = 0.5 or 1/2, 100% chance = 1.0
-- This can also be done in the individual .lua files.
npcChance = 1

--#####################################################################################
---------------------------------------------------------------------------------------
duration 	= 90
stopWatch	= 0
talkTimer	= 3

fed 		= false
isDigest	= false
isPlayer	= false

head		= nil
chest		= nil
legs		= nil
back		= nil

fullhead	= nil
fullchest	= nil
fulllegs	= nil
fullback	= nil

victim		= nil

voreeffect = "npcvore"
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
	
	if #people == 1 and #personalspace == 0 and #eggcheck == 1 then
		
		victim = people[1]
		
		if world.isNpc( victim ) == false then
			isPlayer = true
		end
		
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( victim ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			return
		end
		
		if ( isPlayer and math.random() < playerChance ) or ( isPlayer == false and math.random() < npcChance ) then
			
			local mergeOptions = {
				statusEffects = {
				{
					effect = voreeffect,
					duration = entity.id()
			}}}
			
			if isDigest then
				world.spawnProjectile( dprojectile , world.entityPosition( victim ), entity.id(), {0, 0}, false, mergeOptions)
			else
				world.spawnProjectile( projectile , world.entityPosition( victim ), entity.id(), {0, 0}, false, mergeOptions)
			end
			
			fed = true
			
			entity.setInteractive(false)
			gain()
			
			feedHook()
		else
			isPlayer = false
		end
	end
end

function digest()

	if stopWatch >= duration then		
		fed = false
		
		stopWatch = 0
		
		entity.setInteractive(true)
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
	
	if not fed and math.random(900) == 1 then
		feed()
	elseif fed then
		stopWatch = stopWatch + dt
		digest()
	end
	
	if talkTimer < 3 then
		talkTimer = talkTimer + dt
	end
	
	updateHook()
	
	update = tempUpdate
end

function interact(args)

	world.logInfo("Interacted")

	if talkTimer < 3 then
		world.logInfo("Feeding")
		feed()
	else
		world.logInfo("Timer Reset")
		talkTimer = 0
	end	
--	oldInteract(args)
	interactHook()
	
	return
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

function interactHook()

end