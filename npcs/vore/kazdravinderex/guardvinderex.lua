require "/scripts/vore/npcvore.lua"

playerLines = {		"Ah, nice and comfy.",
					"Have yourself a nice rest in there, my tasty friend.",
					"Rrrrr... Keep squirming, feels wondrful.",
					"Enjoying yourself in there?"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "vinderexlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "vinderexbellylegs",
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