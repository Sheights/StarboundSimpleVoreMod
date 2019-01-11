require "/scripts/vore/npcvore.lua"

playerLines = {		"I'll keep you safe~",
					"Shouldn't have been idling about. I was peckish!",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"Just relax, listen to where you are.. I'm sure it's blissful for you too, heh~"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex	
	legs[2] = {
		name = "sykeslegsbelly",
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

function loseHook()
	if containsPlayer() then
		npc.say("Come back anytime, hehe.")
	end
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end