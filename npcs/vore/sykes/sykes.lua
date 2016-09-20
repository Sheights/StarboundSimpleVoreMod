require "/scripts/vore/npcvore.lua"

playerLines = {		"I'll keep you safe~",
					"Shouldn't have been idling about. I was peckish!",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"Just relax, listen to where you are.. I'm sure it's blissful for you too, heh~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "sykeslegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "sykeslegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		npc.say("Come back anytime, hehe.")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end