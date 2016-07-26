require "/scripts/vore/npcvore.lua"

playerLines = {		"I'm a kid~, I'm a squid~, I'm *URP* ...rather full.",
					"Mmm, you taste a lot better than sushi!",
					"Keep squirming, it feels inkredible~",
					"Easier to carry around than a splatling!",
					"Stay as long as you want. Big bellies are always in style!",
					"Oof, this feels so good~",
					"I wonder if they'll let me into the next turf match like this.",
					"Woomy~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	chest = {
		name = "inklingchest",
		parameters = {
					colorIndex = index
	}}
	
	fullchest = {
		name = "inklingchest",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "inklinglegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "inklingbellylegs",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		npc.say("Come back anytime you feel like a stay in a warm squidkid belly~")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end
