require "/scripts/vore/npcvore.lua"

legs[2] = "lucarionormallegsbelly"

audio = false

playerLines = {	"Our aura is merging.",
				"Luu~ Oh my that feels wonderful!",
				"You are quite feisty, arn't you?",
				"The aura tells me how peaceful you are.",
				"Can you feel my aura?",
				"This is such a warming embrace!",
				"Sleep now child. Tomorrow is a new day.",
				"*mmmmm~*"
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
	npc.setItemSlot( "head", "lucarioshinyhead" )
	npc.setItemSlot( "chest", "lucarioshinychest" )
	npc.setItemSlot( "legs", "lucarioshinylegs" )
	head[1] = "lucarioshinyhead"
	chest[1] = "lucarioshinychest"
	legs[1] = "lucarioshinylegs"
	legs[2] = "lucarioshinylegsbelly"
end