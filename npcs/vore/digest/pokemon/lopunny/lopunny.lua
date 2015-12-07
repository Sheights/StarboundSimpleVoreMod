require "/scripts/vore/npcvore.lua"

legs = "lopunnynormallegs"

fulllegs = "lopunnynormallegsbelly"

isDigest = true

playerLines = {	"Ah, look what I caught!",
				"Don't worry, you won't be in there much longer <3",
				"Lopunny used Swallow! It's super effective <3",
				"Sweeter than peacha!",
				"Bunny bellies best bellies~!",
				"My hidden ability is gastro acid~",
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
		entity.say("You'll be back. I know how great this feels.")
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