require "/scripts/vore/npcvore.lua"

legs[2] = "lopunnynormallegsbelly"

audio = false

playerLines = {	"Who's in a wabbit womb~?",
				"You'll be such a cute little Buneary",
				"I'm gonna be a bunny mommy~!",
				"Hehe. you'll be my next litter~",
				"Enjoying yourself? I know I am!",
				"Don't worry about me. I've fit bigger in there before."
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
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	world.sendEntityMessage( id, "applyStatusEffect", "npceggbase", 60, entity.id() )
end

function releaseHook(input, time)
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggbase", 60, entity.id() )
	end
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