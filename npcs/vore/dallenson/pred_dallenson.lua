require "/scripts/vore/npcvore.lua"

bellyLines = {	"I love that wriggly feeling!",
				"Don't be afraid to ask if you want to be let out.",
				"Feel free to stay as long as you want, I won't hurt you.",
				"S-Stop squirming in there, it tickles!",
				"Mraawr, I love that feeling of being full!"
}
gulpLines = {	"Hehehe! In you go!",
				"Have fun in there!",
				"Down the hatch you go!"
}
gurgleLines = {	""
}
releaseLines = {	"How was it in there?",
					"Feel free to come back anytime!",
					"Sorry if I freaked you out in there.",
					"You gotta pay rent to stay in there longer. Just kidding!"
}
requestLines = {	"S-Sure, if you want!",
					"I'd happily do it and I'll be gentle too!",
					"O-okay. I promise not to hurt you either.",
					"I'll be gentle about it. You have nothing to worry about!"
}
requestLeaveLines = {	"You can come out. I won't force you to stay.",
						"If you don't like it in my belly, I'll let you out.",
						"Awwww, you feel really good in there but if you want out..."
}

function digestHook(id, time, dead)

	sayLine( releaseLines )

end

function releaseHook(input)

	sayLine( requestLeaveLines )
	
end

function initHook()
	
	legs[2] = "dallensonlegsbelly"

end

function feedHook(input)

	sayLine( gulpLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)

end

function requestHook(input)

	sayLine( requestLines )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)

end

function updateHook()

	if containsPlayer() and math.random(700) == 1 then
		sayLines( bellyLines )
	end

end