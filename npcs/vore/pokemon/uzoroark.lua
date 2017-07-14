require "/scripts/vore/npcvore.lua"

legs[2] = "zoroarknormallegsbelly"

audio = false

playerLines = {	"I'm really starting to enjoy this!",
				"This feels so nice<3",
				"I'm very pleased you could share this with me~",
				"I want you... to stay inside me~",
				"Yes... Rub around in there some more. It's so wonderful!",
				"When you get out... Can you call me 'Mom'?"
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
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	world.sendEntityMessage( id, "applyStatusEffect", "npceggbase", 60, entity.id() )
	if containsPlayer() then
		npc.say("Come back anytime. I know you loved it!")
	end
end

function releaseHook(input, time)
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggbase", 60, entity.id() )
	end
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