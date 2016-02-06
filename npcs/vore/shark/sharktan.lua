require "/scripts/vore/npcvore.lua"

legs = "sharktanlegs"

fulllegs = "sharktanlegsbelly"

playerLines = {	"Mmm you're fishfood now~",
				"Sorry meat, you needed a bigger boat...",
				"This is how Jaws was meant to end.",
				"I'll be picking you out of my teeth tonight.",
				"How do you like seafood?",
				"If you find anything interesting in there, bring it back would you?"
}

function loseHook()
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end