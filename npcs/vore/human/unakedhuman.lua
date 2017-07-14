require "/scripts/vore/npcvore.lua"

audio	= false
legs[2] = "humannakedlegsbelly"

playerLines = {	"Ah, so full and gravid with a child in my tummy~",
				"I hope you don't mind stewing in there for a while...Nine months sound good to you?",
				"I'll keep you safe.",
				"I'm pretty sure I'm your mother now...If you don't mind.",
				"Now rest, my baby. You need time to 'bake'~",
				"Mmm...This feels so good...Good thing my cervix sealed you in~",
				"Oof! You sure are a lively one! I'm glad I am carrying a fighter!",
				"Your heartbeat matches mine. Do you feel it? I feel it."
}

function digestHook(id, time, dead)	
	if containsPlayer() then
		npc.say("Why hello, my child~")
	end	
end

function releaseHook()
	if containsPlayer() then
		npc.say("Why hello, my child~")
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end