require "/scripts/vore/npcvore.lua"

isDigest = true

head = "newtblackhead"
legs = "newtblacklegs"

fullhead = "newtblackheadbelly1"

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

	if isPlayer and math.random(900) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
	
	if fed then
		if stopWatch >= 2 then
			entity.setItemSlot( "chest", "newtblackchest" )
			entity.setItemSlot( "legs", "newtblacklegsbelly" )
		elseif	stopWatch >=1 then			
			entity.setItemSlot( "chest", "newtblackchestbelly" )
			entity.setItemSlot( "head", "newtblackheadbelly2" )
		end
	end

end