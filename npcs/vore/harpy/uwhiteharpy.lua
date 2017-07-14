require "/scripts/vore/npcvore.lua"

audio = false

playerLines = {	"It's been a while since I felt like this!",
				"I can't wait for you to meet your new brothers and sisters!",
				"I'll keep you safe.",
				"I always believed this made me your mother.",
				"You will enjoy being a harpy!",
				"This way is much faster than the alternative. Feels better too.",
				"I would like it if you called me mom from now on.",
				"Your heartbeat matches mine. Do you hear it?"
}

function initHook()
	chest[2]	= "harpywhitechestbelly"
	legs[2]		= "harpywhitelegsbelly"
end

function digestHook(id, time, dead)
	world.sendEntityMessage( id, "applyStatusEffect", "npceggbase", 60, entity.id() )
	if containsPlayer then
		npc.say("Resting soundly in an egg. I'll see you in a while my dear!")
	end
end

function releaseHook(input, time)
	if time >= 60 then
		if containsPlayer() then
			npc.say("Resting soundly in an egg. I'll see you in a while my dear!")
		end
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "voreclear", 1, entity.id() )
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "npceggbase", 60, entity.id() )
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end