require "/scripts/vore/npcvore.lua"

isDigest = true

head = "newtgreenhead"
legs = "newtgreenlegs"

fullhead = "newtgreenheadbelly1"

playerLines = {	"...You tasty...",
				"...So full...",
				"...Squirm more...",
				"...I... Love you...",
				"...I'm happy...",
				"...Yum..."
}

function loseHook()
	
	if isPlayer then
		entity.say("...Come back...")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
	
	if fed then
		if stopWatch >= 2 then
			entity.setItemSlot( "chest", "newtgreenchest" )
			entity.setItemSlot( "legs", "newtgreenlegsbelly" )
		elseif	stopWatch >=1 then			
			entity.setItemSlot( "chest", "newtgreenchestbelly" )
			entity.setItemSlot( "head", "newtgreenheadbelly2" )
		end
	end

end