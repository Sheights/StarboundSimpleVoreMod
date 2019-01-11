require "/scripts/vore/npcvore.lua"

isDigest	= true
effect		= "npcdigestvore"

playerLines = {		"Guess who's the better pred? Me~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Mnnng~ Keep squirming, you feel so good in there~"
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