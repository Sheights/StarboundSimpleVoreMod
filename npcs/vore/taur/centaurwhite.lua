require "/scripts/vore/npcvore.lua"

legs = "centaurwhitelegs"

fulllegs = "centaurwhitelegsbelly"

playerLines = {	"The best way to travel cross country!",
				"Yes, this is what I meant by ride. I'm not wearing a saddle if you didn't notice.",
				"Its easier than you being riding on top.",
				"Try not to go to my flanks…",
				"Cityslickers, slick on the throat, slick in the stomach.",
				"Compliments to yer breeder!",
				"Now that's some prime grub!"
}

function loseHook()
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end