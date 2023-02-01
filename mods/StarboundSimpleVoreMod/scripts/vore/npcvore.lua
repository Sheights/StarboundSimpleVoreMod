require "/scripts/vore/exclusions.lua"

---------------------------------------------------------------------------------------
--#####################################################################################
--CONFIG SECTION

npcChance = 1

-- Player Chance is a percent chance that the player will be vored compared to the standard base chance
-- Keep the value anywhere between 0 and 1
-- 0% = 0, 50% = 0.5 or 1/2, 100% chance = 1.0
-- This can also be done in the individual .lua files.
playerChance = 1

-- Audio will activate, Guess what, the audio portion of the mod. This will turn off audio for all preds.
-- For individual preds, you can overide this value to suit your needs.
-- This line can either be "true" or "false"
audio = true

--#####################################################################################
---------------------------------------------------------------------------------------

--Function Preservation

oldInit = init
oldInteract = interact
oldUpdate = update

-----------------------

--Variable Declaration

capacity	= 1
duration 	= 90
reqTimer	= 1
squirmTimer	= 1

speaker		= nil
tempTarget	= nil

isDigest	= false

dead		= {}
isPlayer	= {}
request 	= {}
stopWatch	= {}
victim 		= {}

head		= {}
chest		= {}
legs		= {}
back		= {}

bellyLines		= {}
digestLines		= {}
eatLines		= {}
passLines		= {}
requestLines	= {}

effect = "npcvore"

----------------------

function init()

	for i=0, capacity do
		table.insert(dead, 1, false)
		table.insert(isPlayer, 1, false)
		table.insert(request, 1, false)
		table.insert(stopWatch, 1, 0)
		table.insert(victim, 1, nil)
	end

	head[1] = npc.getItemSlot("head")
	chest[1] = npc.getItemSlot("chest")
	legs[1] = npc.getItemSlot("legs")
	back[1] = npc.getItemSlot("back")
	
	npc.setInteractive(true)	

	oldInit()
	
	initHook()

end

function update(dt)

	tempupdate = update
	tempinteract = interact
	
	if #victim < capacity and isntEaten() and math.random(100) == 1 then
--		sb.logInfo("Attempting to feed")
		feed()
	end
	
	if #victim > 0 then
	
		for i=1, #victim do
			stopWatch[i] = stopWatch[i] + dt
		end
		
		if math.random(500) == 1 and audio then
			world.spawnProjectile( "digestprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
		end
		
		digest()
	
	end
	
	if reqTimer < 0.7 then
		reqTimer = reqTimer + dt
	end
	
	if squirmTimer < 5 then
		squirmTimer = squirmTimer + dt
	end
	
	oldUpdate(dt)
	updateHook(dt)
	update = tempupdate
	interact = tempinteract
	
end

function interact(args)

--	sb.logInfo("Interracted With")
	if isVictim(args.sourceId) then
--		sb.logInfo("Is a Victim")
		if squirmTimer >= 5 then
			squirmTimer = 0
			speaker = args.sourceId
			squirm(args)
		end
		
		if reqTimer >= 0.7 then
			reqTimer = 0
		else
			reqRelease(args)
			reqTimer = 0.7
		end
	else
		if reqTimer >= 0.7 then
			reqTimer = 0
			oldInteract(args)
		elseif #victim >= capacity then
			rub(args)
		elseif isntEaten() then
			reqFeed(args)
		end
	end
	interactHook(args)
end

function containsPlayer()
	for i=1, #victim do
		if isPlayer[i] then
			return true
		end
	end
	return false
end

function isntEaten()
	tempEffects = status.getPersistentEffects("vore")
	if #tempEffects ~= 0 then
		return false
	end
	tempEffects = status.getPersistentEffects("egg")
	if #tempEffects ~= 0 then
		return false
	end
	return true
end

function digest()

	for i=1, #victim do
	
		--victim[i] is sometimes nil.
		local removeit = false
		if victim[i] ~= nil then
			removeit = not world.entityExists( victim[i] )
		else
			removeit = true;
		end
		if removeit then
			for j = i, capacity do
				if j == capacity then
					dead[j] = false
					stopWatch[j] = 0
					victim[j] = nil
					request[j] = false
					isPlayer[j] = false
				else
					dead[j] = dead[j+1]
					stopWatch[j] = stopWatch[j+1]
					victim[j] = victim[j+1]
					request[j] = request[j+1]
					isPlayer[j] = isPlayer[j+1]
				end
			end
			do return end
		end
		if isDigest then
			if not dead[i] and world.entityHealth(victim[i])[1] / world.entityHealth(victim[i])[2] < 0.03 then
				dead[i] = true
				deathHook( victim[i] )
			end
		end
		if stopWatch[i] >= duration and request[i] == false then
			world.sendEntityMessage( victim[i], "applyStatusEffect", "voreclear", 1, entity.id() )
			digestHook( victim[i], stopWatch[i], dead[i] )
			for j = i, capacity do
				if j == capacity then
					dead[j] = false
					stopWatch[j] = 0
					victim[j] = nil
					request[j] = false
					isPlayer[j] = false
				else
					dead[j] = dead[j+1]
					stopWatch[j] = stopWatch[j+1]
					victim[j] = victim[j+1]
					request[j] = request[j+1]
					isPlayer[j] = isPlayer[j+1]
				end
			end
		dress()
		end
	end

end

function dress()

	local temphead
	local tempchest
	local templegs
	local tempback
	
	for i = 1, #victim + 1 do
		if head[i] ~= nil then
			temphead = head[i]
		end
		if chest[i] ~= nil then
			tempchest = chest[i]
		end
		if legs[i] ~= nil then
			templegs = legs[i]
		end
		if back[i] ~= nil then
			tempback = back[i]
		end
	end
	
	npc.setItemSlot( "head", temphead )
	npc.setItemSlot( "chest", tempchest )
	npc.setItemSlot( "legs", templegs )
	npc.setItemSlot( "back", tempback )

end

function exclusionCheck (target)

	if world.isNpc(target) then
		for i = 1, #exclusionList do
			if world.npcType(target) == exclusionList[i] then
				return false
			end
		end
	end
	return true

end

function feed()
	--check area for prey
	local people = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})
	
	if #people == 0 then
--		sb.logInfo("No prey found")
		do return end
	end
--	sb.logInfo("Food Found")
	--check for projectiles
	
	local eggCheck = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player", "projectile"},
		boundMode = "CollisionArea"
	})

	if #people ~= #eggCheck then
--		sb.logInfo("Projectile found")
		do return end
	end

	--select a random victim

	tempTarget = people[math.random(#people)]

	--check the exclusions
	
	if not exclusionCheck(tempTarget) then
--		sb.logInfo("Exclusion Found")
		do return end
	end

	--check already eaten
	
	if isVictim(tempTarget) then
		do return end
	end
	
	--check space between them

	local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( tempTarget ), {"Null", "Block", "Dynamic"}, 1)
	if #collisionBlocks ~= 0 then
--		sb.logInfo("No line of sight")
		return
	end

	if not world.isNpc(tempTarget)then
		if math.random() < playerChance then
			isPlayer[#victim+1] = true
		else
			do return end
		end
	elseif math.random() > npcChance then
		do return end
	end
	
	--send message

	victim[#victim+1] = tempTarget
	world.sendEntityMessage( tempTarget, "applyStatusEffect", effect, duration, entity.id() )
	spawnSoundProjectile( "swallowprojectile" )

	--adjust states
	dress()
	feedHook()
end

function isVictim(input)

	for i = 1, #victim do
		if victim[i] == input then
			do return true end
		end
	end
	do return false end
end

function reqFeed(input)
	
	victim[#victim + 1] = input.sourceId
	request[#victim] = true
	isPlayer[#victim] = true
	world.sendEntityMessage( victim[#victim], "applyStatusEffect", effect, duration, entity.id() )
	
	dress()
	requestHook(input)
end

function reqRelease(input, time)

--	sb.logInfo("Attempting release")
	for i=1, #victim do
		if victim[i] == input.sourceId then
			world.sendEntityMessage( victim[i], "applyStatusEffect", "voreclear", 1, entity.id() )
			releaseHook(input, stopWatch[i])
			for j = i, capacity do

				if j == capacity then
					dead[j] = false
					stopWatch[j] = 0
					victim[j] = nil
					request[j] = false
					isPlayer[j] = false
				else
					dead[j] = dead[j+1]
					stopWatch[j] = stopWatch[j+1]
					victim[j] = victim[j+1]
					request[j] = request[j+1]
					isPlayer[j] = isPlayer[j+1]
				end
			end
			dress()
		end
	end

end

function spawnSoundProjectile( projectilename )
	if enableAudio then
		world.spawnProjectile( projectilename , mcontroller.position() , entity.id(), {0, 0}, false );
	end
end

function sayLine(input)

	if #input <= 0 then
		do return end
	end

	line = input[math.random(#input)]
	if #victim > 0 then
		line = string.gsub( line, "<entityname>", world.entityName( victim[1] ) )
		npc.say( line )
	elseif not speaker == nil then
		line = string.gsub( line, "<entityname>", world.entityName( speaker ) )
		npc.say( line )
	else
		npc.say( input[math.random(#input)])
	end
end

function squirm(args)
	oldInteract(args)
end

function deathHook(input) end
function digestHook(id, time, dead) end
function feedHook() end
function initHook() end
function interactHook(input) end
function releaseHook(input, time) end
function requestHook(input) end
function rub(input) end
function updateHook(input) end