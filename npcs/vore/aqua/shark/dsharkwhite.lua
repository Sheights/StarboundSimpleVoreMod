require "/scripts/vore/npcvore.lua"

burpLock = false
burpTimer = 0
digested = false
isDigest = true

legs = "sharkwhitelegs"

fulllegs = "sharkwhitelegsbelly"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function loseHook()
	
	npc.setItemSlot( "head", "sharkwhiteheadburp" )
	
	if digested then
		world.spawnItem( "bone", world.entityPosition(entity.id()), 3 )
	elseif isPlayer then
		npc.say("...Come back...")
	end
	
	burpLock = true
	digested = false
	isPlayer = false
	burpTimer = 0
	world.spawnProjectile( "burpprojectile" , world.entityPosition( victim ), entity.id(), {0, 0}, false )
	
end

function updateHook(dt)
	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end
	
	if burpLock then
		burpTimer = burpTimer + 3
		if burpTimer >= 500 then
			npc.setItemSlot( "head", "sharkwhitehead" )
			burpLock = false
		end
	end
	
	if digested == false then
		if fed and world.entityHealth(victim)[1] * 100 <= 5 and stopWatch <= 85 then
			digested = true
			if isPlayer then
				npc.say("...Goodbye...")
			end
		end
	end
end