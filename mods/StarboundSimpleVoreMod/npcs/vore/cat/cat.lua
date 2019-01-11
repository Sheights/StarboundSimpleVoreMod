require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! I hope you enjoy learning about the digestive system of cats. <3",
					"Such a scrumptious thing you are~",
					"Ooooo~ I love having you inside my body~",
					"*Purrs* Mmm, hope I can find more like you, so delicious.",
					"I hope having you inside doesn't make me look TOO fat. *Giggles*",
					"Gonna be a shame to let ya out, just love a full belly. *Kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up.",
					"You'll be making my furcoat even more gorgeous soon~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	chest[2] = {
		name = "catchestbelly",
		parameters = {
					colorIndex = index
	}}
	
	legs[2] = {
		name = "catlegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function digestHook(id, time, dead)

	if containsPlayer() then
		npc.say("Thank you so much for feeding me. We are both so going to enjoy your visit~")
	end

end

function updateHook()

	if containsPlayer() and math.random(700) == 1 then
		sayLines( playerLines )
	end

end

