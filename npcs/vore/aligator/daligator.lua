require "/scripts/vore/npcvore.lua"

gatorFlag 	= true
isDigest	= true
effect 		= "npcdigestvore"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...Yum...",
				"...Know your place...",
				"...Natural outcome...",
				"...You food...I eat food...",
				"...I own you...",
				"...Kind of Heavy...",
				"...Mine now..."
}

digestLines = {	"...Getting weaker...",
				"...Not long...",
				"...Melt away...",
				"...Mine now...",
				"URPP..."
}

fatalLines = {	"...All over...",
				"...Bye...",
				"...Done squirming...",
				"...Help didn't come...",
				"...Heh heh heh...",
				"...Is there more?..",
				"...Finished?.."
}

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function initHook()

	index = npc.getItemSlot("legs").parameters.colorIndex
	
	legs[2] = {
		name = "aligatorlegsbelly2",
		parameters = {
					colorIndex = index
	}}
	
	 shrunkBelly = {
		name = "aligatorlegsbelly1",
		parameters = {
					colorIndex = index
	}}

end

function digestHook(id, time, dead)
	
	if containsPlayer and not dead then
		npc.say("...Come back...")
	end
	
end

function updateHook()

	if math.random(700) == 1 and containsPlayer() then
		sayLine ( playerLines )
	end
	
	if #victim > 0 then
		if gatorFlag and world.entityHealth(victim[1])[1] / world.entityHealth(victim[1])[2] < 0.5 then
			if containsPlayer() then
				sayLine ( digestLines )
			end
			npc.setItemSlot( "legs", shrunkBelly )
			gatorFlag = false
		end
	else
		gatorFlag = true
	end

end

function deathHook(input)
	if containsPlayer() then
		sayLine( fatalLines )
	end
end