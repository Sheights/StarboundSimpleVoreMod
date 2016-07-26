require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {		"Surprise! I hope you enjoy learning about the reproductive system of felines. <3",
					"Such a great feeling thing you are~",
					"Ooooo~ Gonna love to make the most out of you~",
					"*Purrs* Mmm, hope I can find more like you, so good~",
					"Gonna be a shame to spurt you out, I just love having a full sac. *Kneads you about*",
					"You'll look good splattered over my walls.",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
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
		npc.say("Ooooh, that felt wonderful. Do come back! *Purrrrrrr*")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end
