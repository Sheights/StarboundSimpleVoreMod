require "/scripts/vore/npcvore.lua"

isDigest = true
effect 	= "npcdigestvore"

playerLines = {		"Surprise! Hope you enjoy learning about the reproductive system of wolves~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to make the most of you~",
					"*purrs* Mmm hope I can find more like you, so good~",
					"Gonna be a shame to let ya out, just love a full sac~ *kneads you about*",
					"Gosh, I bet it's hot in there with all my fur and fat heating you up~",
					"Mnnng~ Keep squirming, you feel so good in there~",
					"You'll make a great addition to my output",
					"Hunters always win, and in this case, they win a fun toy~"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	chest[2] = {
		name = "wolfchestballs",
		parameters = {
					colorIndex = index
	}}
	legs[2] = {
		name = "wolflegsballs",
		parameters = {
					colorIndex = index
	}}
end

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("That felt great having you come out.")
	end
end

function releaseHook(input, time)
	if containsPlayer() then
		npc.say("That felt great having you come out.")
	end
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