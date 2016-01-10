require "/scripts/vore/npcvore.lua"

playerLines = {	"You’re about to become one with nature sweetie. Quite the honour.",
				"Elves taste better, but you’ll do.",
				"You’ll help the plants grow, and importantly, me~",
				"Time to give back to nature.",
				"I won't be hopping, skipping, or jumping anytime soon."
}

isDigest = true

function initHook()
	
	if storage.legs == null then
		legs = entity.getItemSlot("legs").name
		fulllegs = legs .. "belly"
		storage.legs = legs
	else
		legs = storage.legs
		fulllegs = legs .. "belly"
	end
	
end		

function loseHook()
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end