require "/scripts/vore/multivore.lua"

capacity = 2

isDigest = true

playerLines = {	"Hisssssss...."
}

legs = "viperlegs"
fulllegs = "viperlegsbelly"

function digestHook()

	if #victim > 0 then
		entity.setItemSlot( "legs", "viperlegsbelly" .. #victim )
	else
		entity.setItemSlot( "legs", "viperlegs" )
	end
	
end

function initHook()
	
end		

function feedHook()

	entity.setItemSlot( "legs", fulllegs .. #victim )

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		entity.say( playerLines[math.random(#playerLines)])
	end

end