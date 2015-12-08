require "/scripts/vore/npcvore.lua"

isDigest = true

legs = "blacklamia"

fulllegs = "blacklamiabelly"
playerLines = {		"Surprise! Hope you enjoy learning about the digestive system of snakes~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"I bet it feels even tighter then a good squeeze from my coils in there~",
					"Mmmmmm, keep wiggling along, you'll be digested soon enough~",
					"Your bulge is shrinking, are you still solid in there?",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

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


