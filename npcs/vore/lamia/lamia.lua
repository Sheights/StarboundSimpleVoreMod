require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! Hope you enjoy learning about the digestive system of snakes~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"You look much better as a lump.",
					"I hope you aren't TOO fattening~ *giggles*",
					"I bet it feels even tighter then a good squeeze from my coils in there~",
					"Mmmmmm, keep wiggling along, you'll be digested soon enough~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "lamialegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "lamialegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("Another meal tucked away into my coils~ *pats their tail some*")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end