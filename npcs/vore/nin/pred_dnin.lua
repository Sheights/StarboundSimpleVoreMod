require "/scripts/vore/multivore.lua"

isDigest = true

stopWatch	= { 0, 0 }

capacity = 2

request		= { false, false }
victim		= { nil, nil }

playerLines = {}

playerLines[1] = {	"I can feel you getting softer in there.",
	"Soon you'll just be another layer of pudge.",
	"I wonder how much your bones will sell for this time?",
	"I hope you had something valuable on you.",
	"Mmm, I could still go for more :9",
	"Every moment you're in there, more and more of you becomes mine~",
	"I hope the others taste even better than you.",
}

playerLines["eat"] = {	"Ahh, down you go.",
						"Mmm, that's it, get in there.",
						"Mmm, down you go, food.",
						"Such a lovely bulge~",
						"Delicious...",
						"Mmm, squirm all the way down."
}

playerLines["die"] = {	"Ahh...just as you should be.",
						"Another layer of pudge, another set of bones to sell.",
						"*URP* Ahh, delicious~",
						"There's a good meal, churn away in a belly like you were designed.",
						"Mmm, and now you're all mine."
}
playerLines["request"] = {	"Well I certainly won't say no to free food.",
							"You better not try to get out before you're done.",
							"Free pudge? Well okay, down you go, food~"
}

playerLines["release"] = {	"Meh, I should have guessed.",
							"COMPLIANCE",
							"Fine, fine, make room for someone else.",
							"Well don't go in there if you're just going to jump right back out I:"
}

playerLines["exit"] = {	"Bah, I shouldn't be letting you go.",
						"This feels so wrong.",
						"Meh, I'm sure I'll find something even better."
}

function redress()

	digest()
	
end

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", "ninlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "ninlegs" )
	end
	
end

function feedHook()

	if #victim == 1 then
		npc.setItemSlot( "legs", "ninlegsbelly1" )
	else
		npc.setItemSlot( "legs", "ninlegsbelly2" )
	end
	
	if requested then
		npc.say( playerLines["request"][ math.random( #playerLines["request"] )] )
	else
		npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	end
	
end

function updateHook(dt)
	
	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		npc.say( playerLines[ 1 ][ math.random( #playerLines[ 1 ] ) ] )
	end

end

function forceExit()

	npc.say( playerLines["exit"][ math.random( #playerLines["exit"] )] )

	if #victim > 1 then
		npc.setItemSlot( "legs", "ninlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "ninlegs" )
	end

end