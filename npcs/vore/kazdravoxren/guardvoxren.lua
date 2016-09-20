require "/scripts/vore/npcvore.lua"

playerLines = {		"You're stuck in there now, hehe.",
					"Don't worry, I'll keep you safe.",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"Are you suggesting I'd eat you even when it's perfectly safe? Mmm, you might be right."
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "voxrenlegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "voxrenbellylegs",
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