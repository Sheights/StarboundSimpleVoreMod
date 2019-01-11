require "/scripts/vore/npcvore.lua"

burpLock	= false
burpTimer	= 0
digested	= false
wasPlayer 	= false

legs[2] = "sharkwhitelegsbelly"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function digestHook(id, time, dead)

	npc.setItemSlot( "head", "sharkwhiteheadburp" )
	
	if digested then
		world.spawnItem( "bone", world.entityPosition(entity.id()), 3 )
	elseif containsPlayer then
		npc.say("...Come back...")
	end
	
	burpLock = true
	digested = false
	wasPlayer = false
	burpTimer = 0
	world.spawnProjectile( "burpprojectile" , world.entityPosition( entity.id() ), entity.id(), {0, 0}, false )
	
end

function deathHook(input)
	digested = true
	
	if containsPlayer() then
		npc.say("...Goodbye...")
	end
	
end

function feedHook(input)
	if not world.isNpc(tempTarget) then
		wasPlayer = true
	end
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function releaseHook(input, time)

	npc.setItemSlot( "head", "sharkwhiteheadburp" )
	
	if digested then
		world.spawnItem( "bone", world.entityPosition(entity.id()), 3 )
	elseif containsPlayer then
		npc.say("...Come back...")
	end
	
	burpLock = true
	digested = false
	wasPlayer = false
	burpTimer = 0
	world.spawnProjectile( "burpprojectile" , world.entityPosition( entity.id() ), entity.id(), {0, 0}, false )

end

function updateHook(dt)
	if math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines )
	end
	
	if burpLock then
		burpTimer = burpTimer + dt
		if burpTimer >= 2 then
			npc.setItemSlot( "head", "sharkwhitehead" )
			burpLock = false
			burpTimer = 0
		end
	end
end