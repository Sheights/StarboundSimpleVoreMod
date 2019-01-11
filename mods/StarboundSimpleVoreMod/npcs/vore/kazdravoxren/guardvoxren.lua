require "/scripts/vore/npcvore.lua"

playerLines = {		"You're stuck in there now, hehe.",
					"Don't worry, I'll keep you safe.",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"Are you suggesting I'd eat you even when it's perfectly safe? Mmm, you might be right."
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "voxrenbellylegs",
		parameters = {
					colorIndex = index
	}}
end

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("Come back anytime, hehe.")
	end
end

function releaseHook(input, time)
	if containsPlayer() then
		npc.say("Come back anytime, hehe.")
	end
end

function updateHook()

	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end

end