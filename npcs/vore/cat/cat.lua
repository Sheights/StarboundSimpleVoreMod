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

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	chest = {
		name = "catchest",
		parameters = {
					colorIndex = index
	}}
	
	fullchest = {
		name = "catchestbelly",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "catlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "catlegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("Thank you so much for feeding me. We are both so going to enjoy your visit~")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end

