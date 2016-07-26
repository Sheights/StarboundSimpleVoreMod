require "/scripts/vore/npcvore.lua"

playerLines = {	"Soon, you'll be a spirit too!",
				"It's always lovely when I don't need to hunt.",
				"The spirits have gifted you to me, surely!",
				"Now you will help fuel a great hunter!",
				"Welcome to my personal tribe!",
				"Another successful hunt!"
}

legs = "zebrataurlegs"
fulllegs = "zebrataurlegsbelly"

function loseHook()
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end