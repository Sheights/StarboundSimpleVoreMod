require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! I hope you enjoy learning about the reproductive system of foxes. <3",
					"Such a pleasurable thing you are.",
					"Ooooo~ Gonna love to make the most of you~",
					"*Yips* Mmm, hope I can find more like you, feels so good~",
					"Gonna be a shame to let ya out, just love a full sac. *Kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up.",
					"You would make a beatiful puddle~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	chest = {
		name = "foxchest",
		parameters = {
					colorIndex = index
	}}
	
	fullchest = {
		name = "foxchestballs",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "foxlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "foxlegsballs",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		npc.say("Thank you so much for indulging me. You'll enjoy touring my genitals~")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end

