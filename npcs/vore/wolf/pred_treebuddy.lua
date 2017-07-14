require "/scripts/vore/npcvore.lua"

capacity = 2
duration = 90

bellyLines = {	"Can u wiggle some more",
				"Hope ur good in there ",
				"I love u lovely ",
				"U look lovely in there",
				"Oh myh that tickle"
}
gulpLines = {	"Oh myh your tasty",
				"Down the gullet",
				"Nice and full"
}
gurgleLines = {	"That wasnt supposed to happend",
				"You will make nice rumps",
				"A-are you okay ?"
}
releaseLines = {	"Blerf",
					"Better the way in then out",
					"Beuf cya later "
}
requestLines = {	"Want a trip in ?",
					"If ya want ta",
					"A meal wont hurt",
					"*licks his lips *"
}
requestLeaveLines = {	"Ya want out ",
						"Maybe u could stay longuer",
						"Okay let me a second "
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

function deathHook(input)
	if containsPlayer() then
		sayLine( gurgleLines )
	end
end

function digestHook(id, time, dead)
	if containsPlayer() then
		sayLine( releaseLines )
	end
end

function releaseHook(input, time)
	if containsPlayer() then
		sayLine( requestLeaveLines )
	end
end

function feedHook()
	sayLine( gulpLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	sayLine( requestLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( bellyLines )
	end
end