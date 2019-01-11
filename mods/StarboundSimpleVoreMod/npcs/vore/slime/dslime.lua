require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

playerLines = {	"I'm so happy you decided to join me <3",
				"Can I borrow a little of you? I lost some of me when I went for a walk yesterday.",
				"There is no way we could be closer. Well, there is one way~",
				"How are you doing in there? I can feel you're scared. Aww don't be. I'll keep you safe.",
				"Relax and be one with me~",
				"I-I couldn't be happier! Thank you."
}

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex
	legs[2] = {
		name = "slimegreenlegsbelly1",
		parameters = {
					colorIndex = index
	}}
	legsbelly = {
		name = "slimegreenlegsbelly",
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

function releaseHook(input, time)
	if containsPlayer() then
		npc.say("Thank you so much for the time. I hope we can be together again.")
	end
end

function digestHook(id, time, dead)
	if containsPlayer() then
		npc.say("Thank you so much for the time. I hope we can be together again.")
	end	
end

function updateHook(dt)
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
	if stopWatch[1] >= 45 then
		npc.setItemSlot( "legs", legsbelly )
	end
end