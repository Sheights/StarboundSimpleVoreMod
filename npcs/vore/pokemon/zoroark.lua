require "/scripts/vore/npcvore.lua"

legs[2] = "zoroarknormallegsbelly"

playerLines = {	"Thanks for the treat!",
				"I win this time.",
				"So how does it feel being my prey?",
				"I'm sure you'll be okay.",
				"You should know you tasted great!",
				"Zoooooor",
				"Delicious! I'm feel so satisfied! Hehehe"
}

function initHook()
	if storage.shiny == nil and math.random(100) == 1 then
		storage.shiny = true
		makeShiny()
	elseif  storage.shiny == true then
		makeShiny()
	else
		storage.shiny = false
	end
end

function interactHook()
	if math.random(4) == 1 then
		world.spawnProjectile( "zoroarkprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("Come back anytime. I know you loved it!")
	end
end

function releaseHook(input, time)
	if containsPlayer() then
		npc.say("Come back anytime. I know you loved it!")
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end
end

function makeShiny()
	npc.setItemSlot( "head", "zoroarkshinyhead" )
	npc.setItemSlot( "chest", "zoroarkshinychest" )
	npc.setItemSlot( "legs", "zoroarkshinylegs" )
	head[1] = "zoroarkshinyhead"
	chest[1] = "zoroarkshinychest"
	legs[1] = "zoroarkshinylegs"
	legs[2] = "zoroarkshinylegsbelly"
end