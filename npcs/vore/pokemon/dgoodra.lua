require "/scripts/vore/multivore.lua"

isDigest = true

chest = "goodranormalchest"
legs = "goodranormallegs"

midchest = "goodranormalchestmid"
midlegs = "goodranormallegsmid"

fullchest = "goodranormalchestfull"
fulllegs = "goodranormallegsfull"

duration = 120

projectile	= "dragonvoreprojectile"
dprojectile	= "dragondvoreprojectile"

smallLines = {	"It's the best hug!",
				"Dra!",
				"My gooy full course! How scrumptions!",
				"Hahaha. You are getting all gooy now!",
				"I could really go for another one of these.",
				"It's really warm and slimy in there huh? Sounds great!"
			}
			
medLines = {	"You two are so cute together!",
				"Goo!",
				"Hug! Hug!",
				"I love you!",
				"Yaaaaay! Let's play!",
				"I bet it's really sticky in there!",
				"Fufufufu! You're not getting away now!"
			}

largeLines = {	"Heavy!",
				"You're squishing my insides. I can't breathe!",
				"Draaa!",
				"This was a bad idea.",
				"Be gentle...",
				"Is there such thing as too much of a hug?",
				"There's not even enough room for my slime.",
				"I couldn't go for one more...",
				"N-No, I'm still not going to let you out. Don't worry about it. I love you too much"
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