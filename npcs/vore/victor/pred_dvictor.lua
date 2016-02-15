require "/scripts/vore/multivore.lua"

stopWatch	= { 0, 0, 0, 0 }

capacity = 4

request		= { false, false, false, false }
victim		= { nil, nil, nil, nil }

isDigest = true

playerLines = {}

playerLines[1] = {	"Just wait, you'll be part of me soon~"
}

playerLines["eat"] = {	"*Gulp!*"
}

playerLines["die"] = {	"Urp",
						"Burp",
						"Ahhh~"
}

playerLines["release"] = {	"Bleargh!"
}

function redress()

	digest()
	
end

function digestHook()

	entity.say( playerLines[ "release" ][ math.random( #playerLines[ "release" ] ) ] )
	
	if #victim > 0 then
		entity.setItemSlot( "legs", "victorlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "victorlegs" )
	end
	
end

function feedHook()

	entity.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
	entity.setItemSlot( "legs", "victorlegsbelly" .. #victim )
	
	if animFlag == true then
		animTimer = 0
	else
		animFlag = true
	end
	
end

function updateHook(dt)
	
	if math.random(800) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true or request[3] == true or request[4] == true ) then
		entity.say( playerLines[ 1 ][ math.random( #playerLines[ 1 ] ) ] )
	end

end

function forceExit()

	entity.setItemSlot( "legs", "victorlegs" )

end