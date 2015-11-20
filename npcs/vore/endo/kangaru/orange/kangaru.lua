require "/scripts/vore/npcvore.lua"

legs = "kangaruorangelegs"

fulllegs = "kangaruorangelegsbelly"

playerLines = {	"Mmmm, you're better than the pearlpeas <3",
				"No need to wiggle, you'll be a part of me soon.",
				"You feel so lovely in there.",
				"Come back soon. <3"
}

function loseHook()
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(900) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end