require "/scripts/vore/npcvore.lua"

isDigest = true

chest = "wolfcvchest"
legs = "wolfcvlegs"

fullchest = "wolfcvchestballs"
fulllegs = "wolfcvlegsballs"

playerLines = {		"Surprise! Hope you enjoy learning about the reproductive system of wolves~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to make the most of you~",
					"*purrs* Mmm hope I can find more like you, so good~",
					"Gonna be a shame to let ya out, just love a full sac~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"You'll make a great addition to my output",
					"Hunters always win, and in this case, they win a fun toy~"
}

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("That felt great having you come out.")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end




