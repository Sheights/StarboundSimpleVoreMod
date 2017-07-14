require "/scripts/vore/npcvore.lua"

playerLines = {		"Ah, nice and comfy.",
					"Have yourself a nice rest in there, my tasty friend.",
					"Rrrrr... Keep squirming, feels wondrful.",
					"Enjoying yourself in there?"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "vinderexbellylegs",
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