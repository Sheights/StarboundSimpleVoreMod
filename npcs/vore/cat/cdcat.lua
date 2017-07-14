require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {		"Surprise! I hope you enjoy learning about the reproductive system of felines. <3",
					"Such a great feeling thing you are~",
					"Ooooo~ I'm gonna love having you in for a stay~",
					"*Purrs* Mmm, hope I can find more like you, so good~",
					"Gonna be a shame to let you out, I just love having a full sac. *Kneads you about*",
					"You would make a great cum puddle, you know?",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	chest[2] = {
		name = "catchestballs",
		parameters = {
					colorIndex = index
	}}
	
	legs[2] = {
		name = "catlegsballs",
		parameters = {
					colorIndex = index
	}}

end

function digestHook(id, time, dead)

	if containsPlayer() then
		npc.say("Ooooh, that felt wonderful. Do come back! *Purrrrrrr")
	end

end

function updateHook()

	if containsPlayer() and math.random(700) == 1 then
		sayLines( playerLines )
	end

end