require "/scripts/vore/npcvore.lua"

playerLines = {		"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Mrrr~ Keep squirming, you feel wonderful in there~",
					"I got you now~",
					"*Idly hums*",
					"I do hope you enjoy your stay!"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "avalirarulegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "avalirarulegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		npc.say("Thank you so much for filling my tummy. Hope to get to nom ya again soon ^..^")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end