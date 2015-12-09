require "/scripts/vore/npcvore.lua"

legs = "lopunnynormallegs"

fulllegs = "lopunnynormallegsbelly"

playerLines = {	"Ah, look what I caught!",
				"Do I want to give a nickname to the caught meal?",
				"Lopunny used Swallow! It's super effective <3",
				"Sweeter than peacha!",
				"Bunny bellies best bellies~!",
				"I guess i'm a trainer now?",
				"Does this make you my pokenom?",
				"Move around in there some more please."
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

function loseHook()
	
	if isPlayer then
		entity.say("I may be releasing you but I'll always look forward to catching you again <3")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		entity.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	entity.setItemSlot( "head", "lopunnyshinyhead" )
	entity.setItemSlot( "chest", "lopunnyshinychest" )
	entity.setItemSlot( "legs", "lopunnyshinylegs" )
	legs = "lopunnyshinylegs"
	fulllegs = "lopunnyshinylegsbelly"

end