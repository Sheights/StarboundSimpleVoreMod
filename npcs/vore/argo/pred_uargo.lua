require "/scripts/vore/npcvore.lua"

duration = 60
audio = false

playerLines = {	"^red;<3",
				"^white;O^pink;#^white;v^pink;#^white;O",
				"-v- ~ ^red;<3",
				"^red;<3 <3 <3",
				"^red;<3 ^pink;<3 ^red;<3",
				"^red;*love*"
}

function initHook()

	if storage.belly == nil then
		storage.belly = ""
	end
	
end

function feedHook()

	entity.setItemSlot( "head", "argonpcheadbelly1" )
	entity.setItemSlot( "chest", "argonpcchestbelly1" )
	entity.setItemSlot( "legs", "argonpcpantsbelly1" )

	storage.belly = "1"

end

function loseHook()
	
	if isPlayer then
		entity.say("^blue;<3")
	end
	
	entity.setItemSlot( "head", "argonpchead" )
	entity.setItemSlot( "chest", "argonpcchest" )
	entity.setItemSlot( "legs", "argonpcpants" )
	
	storage.belly = ""
	
	isPlayer = false
	
end

function updateHook()

	if entity.isLounging() then
		if fed then
			entity.setItemSlot( "head", "argonpcheadbelly" .. storage.belly .. "blink" )
		else
			entity.setItemSlot( "head", "argonpcheadblink" )
		end
	else
		if fed then
			entity.setItemSlot( "head", "argonpcheadbelly" .. storage.belly )
		else
			entity.setItemSlot( "head", "argonpchead" )
		end
	end
	
	if request then
		if stopWatch > 30 then
			entity.setItemSlot( "head", "argonpcheadbelly2" )
			entity.setItemSlot( "chest", "argonpcchestbelly2" )
			entity.setItemSlot( "legs", "argonpcpantsbelly2" )
			storage.belly = "2"
		elseif stopWatch > 60 then
			entity.setItemSlot( "head", "argonpcheadbelly3" )
			entity.setItemSlot( "chest", "argonpcchestbelly3" )
			entity.setItemSlot( "legs", "argonpcpantsbelly3" )
			storage.belly = "3"
		elseif stopWatch > 90 then
			entity.setItemSlot( "head", "argonpcheadbelly4" )
			entity.setItemSlot( "chest", "argonpcchestbelly4" )
			entity.setItemSlot( "legs", "argonpcpantsbelly4" )
			storage.belly = "4"
		elseif stopWatch > 120 then
			entity.setItemSlot( "head", "argonpcheadbelly5" )
			entity.setItemSlot( "chest", "argonpcchestbelly5" )
			entity.setItemSlot( "legs", "argonpcpantsbelly5" )
			storage.belly = "5"
		end
	end
	
	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end
end