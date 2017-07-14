require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

legs[2] = "lopunnynormallegsbelly"

playerLines = {	"Ah, look what I caught!",
				"Do I want to give a nickname to the caught meal?",
				"Lopunny used Swallow! It's super effective <3",
				"Sweeter than peacha!",
				"Bunny bellies best bellies~!",
				"I guess i'm a trainer now?",
				"Does this make you my pokenom?",
				"Move around in there some more please."
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

function interactHook(input)
	if math.random(4) == 1 then
		world.spawnProjectile( "lopunnyprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end

function makeShiny()
	npc.setItemSlot( "head", "lopunnyshinyhead" )
	npc.setItemSlot( "chest", "lopunnyshinychest" )
	npc.setItemSlot( "legs", "lopunnyshinylegs" )
	head[1] = "lopunnyshinyhead"
	chest[1] = "lopunnyshinychest"
	legs[1] = "lopunnyshinylegs"
	legs[2] = "lopunnyshinylegsfull"
end