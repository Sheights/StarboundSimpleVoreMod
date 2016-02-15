require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {		"I'm a kid~, I'm a squid~, I'm *URP* ...rather full.",
					"Mmm, you taste a lot better than sushi!",
					"Keep squirming, it feels inkredible~",
					"Thanks for the ink refill!",
					"More ink for my next turf war!",
					"Hope you don't make me too fat for Splatfest.",
					"Gonna have to go to Jelly Fresh after you're done~"
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
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
		entity.say("Aww, I wasn't done with you..")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end
