require "/scripts/vore/npcvore.lua"

chest[2] = "goodranormalchestmid"
legs[2] = "goodranormallegsmid"

chest[4] = "goodranormalchestfull"
legs[4] = "goodranormallegsfull"

capacity = 3
duration = 120

audio = false

playerLines = {}

playerLines[1] = {	"I can't wait to hug you when you're out!",
				"Just listen to my heartbeat and relax!",
				"If you think it's sticky now, just wait!",
				"It's a bit odd not having arms for a while but I'll help you through it.",
				"Gooo~"
			}
			
playerLines[2] = {	"So cute!",
				"Hug! Hug!",
				"I love you!",
				"Oooh! You'll be sibblings!",
				"I hope you play nice both now and after!",
				"You make me feel amazing. Thank you!",
				"Gooodraaaaa"
			}

playerLines[3] = {	"Heavy!",
				"You're squishing my insides. I can't breathe",
				"Draaa!",
				"This was a bad idea.",
				"Be gentle to your mom...",
				"It's the least a mother can do...",
				"Triplets may have been too much."
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

function interactHook(input)
	if math.random(4) == 1 then
		world.spawnProjectile( "goodraprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines[#victim] )
	end
end

function makeShiny()
	npc.setItemSlot( "chest", "goodrashinychest" )
	npc.setItemSlot( "legs", "goodrashinylegs" )
	chest[1] = "goodrashinychest"
	legs[1] = "goodrashinylegs"
	chest[2] = "goodrashinychestmid"
	legs[2] = "goodrashinylegsmid"
	chest[4] = "goodrashinychestfull"
	legs[4] = "goodrashinylegsfull"
end