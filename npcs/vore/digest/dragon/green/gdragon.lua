require "/scripts/vore/npcvore.lua"

isDigest = true

legs = "dragongreenlegs"
midlegs = "dragongreenlegsmid"
fulllegs = "dragongreenlegsfull"

duration = 120

projectile	= "dragonvoreprojectile"
dprojectile	= "dragondvoreprojectile"

smallLines = {	"You must be so lonely in there.",
				"Barely a meal.",
				"I can bet you are comfortable",
				"I have been told my gut is very spacious. Enjoy it while you are alone!"
			}
			
medLines = {	"I hope you two are getting along.",
				"A fine meal!",
				"Stop figthing in there. It's only natural you would be food.",
				"I've never been a one prey dragon."
			}

largeLines = {	"Now this is more like it!",
				"I'm stuffed!",
				"You three have got to be the most delicious I've had in a while.",
				"Pretty cramped in there is it? Ha!"
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