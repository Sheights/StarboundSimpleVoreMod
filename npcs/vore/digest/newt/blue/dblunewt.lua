require "/scripts/vore/npcvore.lua"

isDigest = true

head = "newtbluehead"
legs = "newtbluelegs"

fullhead = "newtblueheadbelly1"

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
			entity.setItemSlot( "chest", "newtbluechest" )
			entity.setItemSlot( "legs", "newtbluelegsbelly" )
		elseif	stopWatch >=1 then			
			entity.setItemSlot( "chest", "newtbluechestbelly" )
			entity.setItemSlot( "head", "newtblueheadbelly2" )
		end
	end

end