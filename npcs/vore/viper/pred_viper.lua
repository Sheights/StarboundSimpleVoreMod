require "/scripts/vore/multivore.lua"

capacity = 2

playerLines = {	"Hisssssss...."
}

legs = "viperlegs"
fulllegs = "viperlegsbelly"

function digestHook()

	if #victim > 0 then
		npc.setItemSlot( "legs", "viperlegsbelly" .. #victim )
	else
		npc.setItemSlot( "legs", "viperlegs" )
	end
	
end

function initHook()
	
end		

function feedHook()

	npc.setItemSlot( "legs", fulllegs .. #victim )

end

function updateHook()

	if isPlayer and math.random(700) == 1 and ( playerTimer < duration or request[1] == true or request[2] == true ) then
		npc.say( playerLines[math.random(#playerLines)])
	end

end