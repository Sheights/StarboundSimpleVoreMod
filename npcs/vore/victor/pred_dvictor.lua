require "/scripts/vore/multivore.lua"

stopWatch	= { 0, 0, 0, 0 }

capacity = 4

request		= { false, false, false, false }
victim		= { nil, nil, nil, nil }

isDigest = true
fauxrequested = false

playerLines = {}

playerLines[1] = {	"Just wait, you'll be part of me soon~",
					"It feels sooo nice to have prey dying inside of me.",
					"I love when they squirm.",
					"You were delicious",
					"Just let my body do its work with you.",
					"*gurgle*"
}

playerLines["eat"] = {	"*Gulp!*"
}

playerLines["die"] = {	"Urp",
						"Burp",
						"Ahhh~"
}

playerLines["release"] = {	"Bleargh!"
}

playerLines["request"] = {	"If you want to die so much, then be it.",
							"Do you really want to die that much? Okay",
							"Fine by me."
}

playerLines["plea"] = {	"Why would I do that?",
						"No way.",
						"I don't like spitting out.",
						"Definitely not.",
						"Oh come on, I need your vitamins and minerals.",
						"If I release you, I'll have to do it with everyone."
}

function redress()

	digest()
	
end

function digestHook()

	npc.say( playerLines[ "release" ][ math.random( #playerLines[ "release" ] ) ] )
	
	if #victim > 0 then
		npc.setItemSlot( "legs", "victorlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "victorlegs" )
	end
	
end

function feedHook()

	if fauxrequested then
		npc.say( playerLines["request"][ math.random( #playerLines["request"] )] )
	else
		npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	end
	fauxrequested = false
	npc.setItemSlot( "legs", "victorlegsbelly" .. #victim )
	
end

function interact(args)
	
	if talkTimer < 1 then
	
		if isVictim( world.entityName( args.sourceId ) ) then
		
			npc.say( playerLines["plea"][ math.random( #playerLines["plea"] )] )
		
		else
			fauxrequested = true
			feed()
		end
		
		talkTimer = 1
		
	else
		talkTimer = 0
	end

	interactHook()
	oldInteract(args)

	return nil

end

function updateHook(dt)
	
	if math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		npc.say( playerLines[ 1 ][ math.random( #playerLines[ 1 ] ) ] )
	end

end

function forceExit()

	npc.setItemSlot( "legs", "victorlegs" )

end