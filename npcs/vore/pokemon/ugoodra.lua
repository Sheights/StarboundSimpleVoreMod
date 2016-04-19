require "/scripts/vore/multivore.lua"

chest = "goodranormalchest"
legs = "goodranormallegs"

midchest = "goodranormalchestmid"
midlegs = "goodranormallegsmid"

fullchest = "goodranormalchestfull"
fulllegs = "goodranormallegsfull"

duration = 120

projectile	= "dragonvoreprojectile"
voreeffect = "dragonUB"

audio = false

smallLines = {	"I can't wait to hug you when you're out!",
				"Just listen to my heartbeat and relax!",
				"If you think it's sticky now, just wait!",
				"It's a bit odd not having arms for a while but I'll help you through it.",
				"Gooo~"
			}
			
medLines = {	"So cute!",
				"Hug! Hug!",
				"I love you!",
				"Oooh! You'll be sibblings!",
				"I hope you play nice both now and after!",
				"You make me feel amazing. Thank you!",
				"Gooodraaaaa"
			}

largeLines = {	"Heavy!",
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

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "goodraprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function updateHook()

	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true ) then
	
		if #victim == 1 then
			entity.say( smallLines[math.random(#smallLines)])
		elseif #victim == 2 then
			entity.say( medLines[math.random(#medLines)])
		elseif #victim == 3 then
			entity.say( largeLines[math.random(#largeLines)])
		end
		
	end

end

function makeShiny()

	entity.setItemSlot( "chest", "goodrashinychest" )
	entity.setItemSlot( "legs", "goodrashinylegs" )
	chest = "goodrashinychest"
	legs = "goodrashinylegs"
	midchest = "goodrashinychestmid"
	midlegs = "goodrashinylegsmid"
	fullchest = "goodrashinychestfull"
	fulllegs = "goodrashinylegsfull"

end