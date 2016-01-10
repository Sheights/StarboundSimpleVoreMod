require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! Hope you enjoy learning about the reproductive system of felines~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to make the most of you",
					"*purrs* Mmm hope I can find more like you, so good",
					"Gonna be a shame to let ya out, just love a full sac~ *kneads you about*",
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
		name = "catchestballs",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "catlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "catlegsballs",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("Ooooh, that felt wonderful. Do come back *purrrrrrr*")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end