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

smallLines = {	"Goo?",
				"Dra!"
			}
			
medLines = {	"Goo, Dra",
				"Dra! Dra!",
				"Goodra!"
			}

largeLines = {	"Gooo~",
				"Goodraaaa~",
				"Draaa~"
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

function updateHook()

	if math.random(300) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true ) then
	
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