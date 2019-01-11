require "/scripts/vore/npcvore.lua"

playerLines = {		"I'll keep you safe~",
					"Enemies can't get you in there~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"It's too dangerous to be walking around by yourself, stay in me a while~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs[2] = {
		name = "avalirarulegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function digestHook(id, time, dead) end

	if containsPlayer() then
		npc.say("Thank you so much for filling my tummy. Hope to get to nom ya again soon ^..^")
	end

end

function updateHook()

	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end

end