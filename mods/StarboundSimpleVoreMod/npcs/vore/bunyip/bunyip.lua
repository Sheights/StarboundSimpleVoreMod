require "/scripts/vore/npcvore.lua"

playerLines = {	"You just have a good long rest in there - Going to be a long time until you're outstaying your welcome~.",
				"Oof...Almost seems a shame to let you out, I could get used to feeling this heavy...",
				"If you have any friends who might want want to fill me up as well, bring them over, okay?",
				"Can you please move your arm to where it was a moment ago? That was feeling quite nice...",
				"Do you think you making me bigger makes me look more or less intimidating? Be honest~.",
				"Still kind of hungry, honestly...do you mind if I get some fish as well, or - ...No? Okay."
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs = {
		name = "bunyiplegs",
		parameters = {
					colorIndex = index
	}}
	
	fulllegs = {
		name = "bunyiplegsbelly",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()

end

function loseHook()

--	if isPlayer then
--	end
	isPlayer = false

end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end