require "/scripts/vore/npcvore.lua"

legs = "lucarionormallegs"

fulllegs = "lucarionormallegsbelly"

playerLines = {	"That feels great. Don't stop moving, OK?",
				"I am your master now!",
				"I feel so full!",
				"Our spirits are combined! I feel stronger... and sleepy.",
				"Stay as long as you want!",
				"'Carioooooo"
}

function initHook()
	
	if storage.shiny == nil and math.random(100) == 1 then
		storage.shiny = true
		makeShiny()
	elseif  storage.shiny == true then
		makeShiny()
	else
		storage.shiny = false
	end
	
end

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "lucarioprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()
	
	if isPlayer then
		entity.say("Don't you feel it? We are becoming one. In more than one way!")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	entity.setItemSlot( "head", "lucarioshinyhead" )
	entity.setItemSlot( "chest", "lucarioshinychest" )
	entity.setItemSlot( "legs", "lucarioshinylegs" )
	legs = "lucarioshinylegs"
	fulllegs = "lucarioshinylegsbelly"

end