require "/scripts/vore/npcvore.lua"

legs = "humanclothedlegs"

fulllegs = "humanclothedlegsbelly"

duration = 60

audio = false

playerLines = {	"Ah, so full and gravid with a child in my tummy~",
				"I hope you don't mind stewing in there for a while...Nine months sound good to you?",
				"I'll keep you safe.",
				"I'm pretty sure I'm your mother now...If you don't mind.",
				"Now rest, my baby. You need time to 'bake'~",
				"Mmm...This feels so good...Good thing my cervix sealed you in~",
				"Oof! You sure are a lively one! I'm glad I am carrying a fighter!",
				"Your heartbeat matches mine. Do you feel it? I feel it."
}

function loseHook()
	
	if isPlayer then
		npc.say("Why hello, my daughter~")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end
end