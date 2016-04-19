require "/scripts/vore/exclusions.lua"

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

-- NPC Chance is a percent chance that an NPC will be vored when the feed function is called.
-- Keep the value anywhere between 0 and 1
-- 0% = 0, 50% = 0.5 or 1/2, 100% chance = 1.0
-- This can also be done in the individual .lua files.
npcChance = 1

-- Audio will activate, Guess what, the audio portion of the mod. This will turn off audio for all preds.
-- For individual preds, you can overide this value to suit your needs.
-- This line can either be "true" or "false"
audio = true

-- Enabling Preds on Ships will allow your predators to devour players on your ship. We do this by removing
-- the player invincibility on ships. There is no easy way to communicate between pred and status effect
-- so I can't open and close this window selectively, without fail, and without breaking it. Enabling Preds
-- on ships will remove your invincibility on your ship only. This will probably remove it for every server
-- you go to forever. I could easily fix this but the solution could be used for a great amount of griefing
-- so I won't be including it in the mod. The only consequences I can think of are you will take a small
-- amount of fall damage on your ship if you jump far enought, and beaming to your ship won't make fire/acid
-- go away like normal. If you don't want this, it is disabled by default, if you do want this, you have read
-- all this and realize the risk. If you join a server with this option enabled, just don't put preds on your
-- ship. You must also remove them from your ship before joining a server with this configuration. You need
-- to enable this on both this script and multivore.lua script, should you want this to apply to that group.
predsOnShips = false
--#####################################################################################
---------------------------------------------------------------------------------------
duration 	= 90
stopWatch	= 0
talkTimer	= 1
temp		= 0

fed 		= false
isDigest	= false
isPlayer	= false
request		= false

head		= nil
chest		= nil
legs		= nil
back		= nil

fullhead	= nil
fullchest	= nil
fulllegs	= nil
fullback	= nil

victim		= nil

voreeffect	= "npcvore"
projectile	= "npcvoreprojectile"

digestsound		= "digestprojectile"
swallowsound 	= "swallowprojectile"


function init()

	oldInit()
	entity.setInteractive(true)

	if predsOnShips then
		world.setProperty("invinciblePlayers", false)
	end
	
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
		
		if world.isNpc( victim ) then
			for i = 1, #exclusionList do
				if world.entityName(victim) == exclusionList[i] then
					return
				end
			end
		else
			isPlayer = true
		end
		
		local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( victim ), {"Null", "Block", "Dynamic"}, 1)
		if #collisionBlocks ~= 0 then
			isPlayer = false
			return
		end
		
		if ( isPlayer and ( math.random() < playerChance or request ) ) or ( isPlayer == false and math.random() < npcChance ) then
			
			temp = entity.id()
			
			if request then
				temp = temp + 20000
			end
			
			if isDigest then
				temp = temp + 10000
			end
			
			local mergeOptions = {
				statusEffects = {
				{
					effect = voreeffect,
					duration = temp
			}}}
			
			world.spawnProjectile( projectile , world.entityPosition( victim ), entity.id(), {0, 0}, false, mergeOptions)
			
			fed = true
		
			gain()			
			feedHook()
		else
			isPlayer = false
		end
	end
	
	if fed == false then
		request = false
	end
	
end

function digest()

	if stopWatch >= duration then
		fed = false
		request = false
		isPlayer = false
		
		lose()
		
		stopWatch = 0
		
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
	
	if audio then
		world.spawnProjectile( swallowsound , mcontroller.position() , entity.id(), {0, 0}, false )
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
	
	tempupdate = update
	tempinteract = interact
	oldUpdate(dt)

	requestLeave = false
	if not fed and math.random(400) == 1 then
		feed()
	elseif fed then	
	
		if math.random(350) == 1 and audio then
			world.spawnProjectile( digestsound , mcontroller.position(), entity.id(), {0, 0}, false )
		end
		
		if request == false then
			digest()
		end
		
		stopWatch = stopWatch + dt
	end

	if talkTimer < 1 then
		talkTimer = talkTimer + dt
	end

	updateHook()
	updateHook(dt)

	update = tempupdate
	interact = tempinteract
end

function interact(args)
	
	if talkTimer < 1 then
	
		if stopWatch >= 1 and fed then

			world.spawnProjectile( "cleanser" , mcontroller.position(), entity.id(), {0, 0}, true )
			stopWatch = duration
			digest()
			
		else
			request = true
			feed()
		end
		
	else
		talkTimer = 0
	end

	interactHook()
	oldInteract(args)

	return nil

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

function updateHook(dt)

end

function interactHook()

end