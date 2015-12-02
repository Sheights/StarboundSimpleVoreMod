require "/scripts/vore/npcvore.lua"

legs = "avalilegs"

fulllegs = "avalilegsbelly"

playerLines = {		"Guess who's the better pred? Me~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("Thank you so much for filling my tummy. Hope to get to nom ya again soon ^..^")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(300) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end