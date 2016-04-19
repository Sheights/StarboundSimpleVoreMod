require "/scripts/vore/npcvore.lua"

legs = "zoroarknormallegs"

fulllegs = "zoroarknormallegsbelly"

playerLines = {	"Thanks for the treat!",
				"I win this time.",
				"So how does it feel being my prey?",
				"I'm sure you'll be okay.",
				"You should know you tasted great!",
				"Zoooooor",
				"Delicious! I'm feel so satisfied! Hehehe"
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
		world.spawnProjectile( "zoroarkprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()
	
	if isPlayer then
		entity.say("Come back anytime. I know you loved it!")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	entity.setItemSlot( "head", "zoroarkshinyhead" )
	entity.setItemSlot( "chest", "zoroarkshinychest" )
	entity.setItemSlot( "legs", "zoroarkshinylegs" )
	legs = "zoroarkshinylegs"
	fulllegs = "zoroarkshinylegsbelly"

end