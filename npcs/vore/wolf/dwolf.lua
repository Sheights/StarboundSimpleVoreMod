require "/scripts/vore/npcvore.lua"

isDigest = true

playerLines = {		"Surprise! Hope you enjoy learning about the digest system of wolves~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"You'll make a great addition to my pack... Of fat!",
					"Hunters always win, and in this case, they win a tasty meal~"
}

function initHook()

	index = entity.getItemSlot("legs").parameters.colorIndex
	
	chest = {
		name = "wolfchest",
		parameters = {
					colorIndex = index
	}}
	
	fullchest = {
		name = "wolfchestbelly",
		parameters = {
					colorIndex = index
	}}
	
	legs = {
		name = "wolflegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "wolflegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

	if isPlayer then
		entity.say("Welcome to my personal pack of belly fat~<3")
	end

	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end
