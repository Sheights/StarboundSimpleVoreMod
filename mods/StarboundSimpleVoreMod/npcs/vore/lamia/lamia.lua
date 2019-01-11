require "/scripts/vore/npcvore.lua"

playerLines = {		"Surprise! Hope you enjoy learning about the digestive system of snakes~<3",
					"Such a scrumptious thing you are~",
					"Ooooo~ Gonna love to add ya to my body~",
					"You look much better as a lump.",
					"I hope you aren't TOO fattening~ *giggles*",
					"I bet it feels even tighter then a good squeeze from my coils in there~",
					"Mmmmmm, keep wiggling along, you'll be digested soon enough~",
					"Mnnng~ Keep squirming, you feel so good in there~"
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "lamialegsbelly",
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

function deathHook()
	npc.say("Another meal tucked away into my coils~ *pats their tail some*")
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end