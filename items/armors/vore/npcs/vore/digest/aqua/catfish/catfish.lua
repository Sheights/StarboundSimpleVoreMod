require "/scripts/vore/npcvore.lua"

burpLock = false
burpTimer = 0
digested = false
isDigest = true

legs = "catfishlegs"

fulllegs = "catfishlegsbelly"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function loseHook()
	
	entity.setItemSlot( "head", "catfishheadburp" )
	
	if digested then
		world.spawnItem( "bone", world.entityPosition(entity.id()), 3 )
	elseif isPlayer then
		entity.say("...Come back...")
	end
	
	burpLock = true
	digested = false
	isPlayer = false
	
end

function updateHook(dt)
	dt = dt or 0.25
	if isPlayer and math.random(450) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
	
	if burpLock then
		burpTimer = burpTimer + dt
		if burpTimer >= 0.5 then
			entity.setItemSlot( "head", "catfishhead" )
			burpLock = false
		end
	end
	
	if digested == false then
		if fed and world.entityHealth(victim)[1] * 100 <= 5 and stopWatch <= 85 then
			digested = true
			if isPlayer then
				entity.say("...Goodbye...")
			end
		end
	end
end