require "/scripts/vore/npcvore.lua"

playerLines = {
					"Such a scrumptious thing you are, <entityname>~",
					"Mnnng~ Keep squirming, <entityname>, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	legs[2] = {
		name = "avalilegsbelly",
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
		npc.say("Thank you so much for filling my tummy. Hope to get to nom ya again soon ^..^")
	end

end

function updateHook()

	if  math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines )
	end
	
end