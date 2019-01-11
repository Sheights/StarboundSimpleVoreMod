require "/scripts/vore/npcvore.lua"

isDigest = true
effect 	= "npcdigestvore"

capacity = 2
duration = 90

playerLines = {		"Surprise! Hope you enjoy learning about the digest system of wolves~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"*purrs* Mmm hope I can find more like you, so delicious~",
					"I hope you aren't TOO fattening~ *giggles*",
					"Gonna be a shame to let ya out, just love a full belly~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"You'll make a great addition to my pack... Of fat!",
					"Hunters always win, and in this case, they win a tasty meal~"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "wolfnewlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	legs[3] = {
		name = "wolfnewlegsbelly2",
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

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end