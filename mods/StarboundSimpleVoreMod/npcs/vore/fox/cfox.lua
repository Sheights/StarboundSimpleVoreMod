require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! I hope you enjoy learning about the reproductive system of foxes. <3",
					"Such a pleasurable thing you are.",
					"Ooooo~ Gonna love to make the most of you~",
					"*Yips* Mmm, hope I can find more like you, feels so good~",
					"Gonna be a shame to let ya out, just love a full sac. *Kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up.",
					"You would make a beatiful puddle~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex

	chest[2] = {
		name = "foxchestballs",
		parameters = {
					colorIndex = index
	}}

	legs[2] = {
		name = "foxlegsballs",
		parameters = {
					colorIndex = index
	}}

end

function feedHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook()

	if containsPlayer() and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		sayline( playerLines )
	end

end

