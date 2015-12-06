require "/scripts/vore/npcvore.lua"

chest = "harpybluechest"
legs = "harpybluelegs"

fullchest = "harpybluechestbelly"
fulllegs = "harpybluelegsbelly"

voreeffect = "harpyvore"
projectile = "npcharpyvoreprojectile"

duration = 60

audio = false

playerLines = {	"It's been a while since I felt like this!",
				"I can't wait for you to meet your new brothers and sisters!",
				"I'll keep you safe.",
				"I always believed this made me your mother.",
				"You will enjoy being a harpy!",
				"This way is much faster than the alternative. Feels better too.",
				"I would like it if you called me mom from now on.",
				"Your heartbeat matches mine. Do you hear it?"
}

function loseHook()
	
	if isPlayer then
		entity.say("Resting soundly in an egg. I'll see you in a while my dear!")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(300) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
end