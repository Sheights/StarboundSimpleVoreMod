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

function digestHook()
	
	if request then
		npc.say( requestLeaveLines[ math.random( #requestLeaveLines ) ] )
	else
		npc.say( releaseLines[ math.random( #releaseLines ) ] )
	end
	
end

function initHook()
	
	legs = "dallensonlegs"
	
	fulllegs = "dallensonlegsbelly"

end

function feedHook()
	
	if request == true then
		npc.say( requestLines[ math.random( #releaseLines ) ] )
	else
		npc.say( gulpLines[ math.random( #gulpLines ) ] )
	end

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( stopWatch < duration or request ) then
		npc.say( bellyLines[math.random(#bellyLines)])
	end

end