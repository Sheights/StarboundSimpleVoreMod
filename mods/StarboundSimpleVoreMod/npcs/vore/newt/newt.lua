require "/scripts/vore/npcvore.lua"

animFlag	= false
animTimer	= 0 

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	head = {
		name = "newthead",
		parameters = {
					colorIndex = index
	}}
	legs = {
		name = "newtlegs",
		parameters = {
					colorIndex = index
	}}
	chest = {
		name = "newtchest",
		parameters = {
					colorIndex = index
	}}
	fullhead = {
		name = "newtheadbelly1",
		parameters = {
					colorIndex = index
	}}
	legsbelly = {
		name = "newtlegsbelly",
		parameters = {
					colorIndex = index
	}}
	chestbelly = {
		name = "newtchestbelly",
		parameters = {
					colorIndex = index
	}}
	headbelly = {
		name = "newtheadbelly2",
		parameters = {
					colorIndex = index
	}}
end

function dress()
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	npc.setItemSlot( "head", fullhead )
	animFlag = true
	animTimer = 0
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	npc.setItemSlot( "head", fullhead )
	animFlag = true
	animTimer = 0
end

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("...Come back...")
	end
	npc.setItemSlot( "head", head )
	npc.setItemSlot( "chest", chest )
	npc.setItemSlot( "legs", legs )
	animFlag = false
end

function releaseHook(input, time)
	if containsPlayer() then
		npc.say("...Come back...")
	end
	npc.setItemSlot( "head", head )
	npc.setItemSlot( "chest", chest )
	npc.setItemSlot( "legs", legs )
	animFlag = false
end

function updateHook(dt)

	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
	
	if animFlag then
		if animTimer >= 2 then
			npc.setItemSlot( "chest", chest )
			npc.setItemSlot( "legs", legsbelly )
			animFlag = false
			animTimer = 0
		elseif	animTimer >=1 then
			npc.setItemSlot( "chest", chestbelly )
			npc.setItemSlot( "head", headbelly )
		end
		animTimer = animTimer + dt
	end

end