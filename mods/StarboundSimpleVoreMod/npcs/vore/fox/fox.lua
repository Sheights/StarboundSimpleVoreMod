require "/scripts/vore/npcvore.lua"

capacity = 2

playerLines = {		"Surprise! I hope you enjoy learning about the digestive system of foxes. <3",
					"Such a scrumptious thing you are~",
					"Ooooo~ I love having you inside my body~",
					"*Yips* Mmm, hope I can find more like you, so delicious~",
					"I hope you aren't making me look TOO fat. *Giggles*",
					"Gonna be a shame to let ya out, just love a full belly. *Kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up.",
					"You would make my furcoat so gorgeous~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	legs[2] = {
		name = "foxnewlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	
	legs[3] = {
		name = "foxnewlegsbelly2",
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

	if containsPlayer() and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		sayline( playerLines )
	end

end

