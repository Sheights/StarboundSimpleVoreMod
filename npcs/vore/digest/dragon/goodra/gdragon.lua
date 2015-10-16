require "/scripts/vore/multivore.lua"

isDigest = true

legs = "dragongoodralegs"
midlegs = "dragongoodralegsmid"
fulllegs = "dragongoodralegsfull"

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
			
function updateHook()

	if math.random(900) == 1 and playerTimer < duration then
	
		if occupency == 1 then
			entity.say( smallLines[math.random(#smallLines)])
		elseif occupency == 2 then
			entity.say( medLines[math.random(#medLines)])
		else
			entity.say( largeLines[math.random(#largeLines)])
		end
		
	end
end