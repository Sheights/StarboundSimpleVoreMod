require "/scripts/vore/npcvore.lua"

chest[2] = "goodranormalchestmid"
legs[2] = "goodranormallegsmid"

chest[4] = "goodranormalchestfull"
legs[4] = "goodranormallegsfull"

capacity = 3
duration = 120

isDigest	= true
effect 		= "npcdigestvore"

playerLines = {}

playerLines[1] = {	"It's the best hug!",
				"Dra!",
				"My gooy full course! How scrumptions!",
				"Hahaha. You are getting all gooy now!",
				"I could really go for another one of these.",
				"It's really warm and slimy in there huh? Sounds great!"
			}
			
playerLines[2] = {	"You two are so cute together!",
				"Goo!",
				"Hug! Hug!",
				"I love you!",
				"Yaaaaay! Let's play!",
				"I bet it's really sticky in there!"
			}

playerLines[3] = {	"Heavy!",
				"You're squishing my insides. I can't breathe!",
				"Draaa!",
				"This was a bad idea.",
				"Be gentle...",
				"Is there such thing as too much of a hug?",
				"There's not even enough room for my slime.",
				"I couldn't go for one more...",
				"N-No, I'm still not going to let you out. Don't worry about it. I love you too much."
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
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
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