require "/scripts/vore/npcvore.lua"

playerLines = {	"The best way to travel cross country!",
				"Yes, this is what I meant by ride. I'm not wearing a saddle if you didn't notice.",
				"Its easier than you being riding on top.",
				"Don't worry, my back is sturdy enough.",
				"Better than most of the things I eat!",
				"It takes a lot of energy to run as much as I do!"
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