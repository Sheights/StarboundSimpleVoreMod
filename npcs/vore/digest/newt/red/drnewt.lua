require "/scripts/vore/npcvore.lua"

isDigest = true

head = "newtredhead"
legs = "newtredlegs"

fullhead = "newtredheadbelly1"

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
			entity.setItemSlot( "chest", "newtredchest" )
			entity.setItemSlot( "legs", "newtredlegsbelly" )
		elseif	stopWatch >=1 then			
			entity.setItemSlot( "chest", "newtredchestbelly" )
			entity.setItemSlot( "head", "newtredheadbelly2" )
		end
	end

end