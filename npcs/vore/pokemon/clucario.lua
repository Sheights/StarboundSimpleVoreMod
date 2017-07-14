require "/scripts/vore/npcvore.lua"

legs[2] = "lucarioballs"

playerLines = {	"That feels great. Don't stop moving, OK?",
				"I am your master now!",
				"This would be a good spot for a pokeball pun, wouldn't it?",
				"I feel so full!",
				"Our spirits are combined! I feel stronger... and sleepy.",
				"Stay as long as you want!",
				"'Carioooooo"
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
		world.spawnProjectile( "lucarioprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function feedHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end

function makeShiny()
	npc.setItemSlot( "head", "lucarioshinyhead" )
	npc.setItemSlot( "chest", "lucarioshinychest" )
	npc.setItemSlot( "legs", "lucarioshinylegs" )
	head[1] = "lucarioshinyhead"
	chest[1] = "lucarioshinychest"
	legs[1] = "lucarioshinylegs"
	legs[2] = "lucarioshinylegsballs"
end