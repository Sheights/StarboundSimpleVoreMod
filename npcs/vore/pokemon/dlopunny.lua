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

function interactHook()

	if math.random(4) == 1 then
		world.spawnProjectile( "lopunnyprojectile" , mcontroller.position(), entity.id(), {0, 0}, false )
	end
	
end

function loseHook()
	
	if isPlayer then
		npc.say("You'll be back. I know how great this feels.")
	end
	
	isPlayer = false
	
end

function updateHook()

	if isPlayer and math.random(700) == 1 then
		npc.say( playerLines[math.random(#playerLines)])
	end

end

function makeShiny()

	npc.setItemSlot( "head", "lopunnyshinyhead" )
	npc.setItemSlot( "chest", "lopunnyshinychest" )
	npc.setItemSlot( "legs", "lopunnyshinylegs" )
	legs = "lopunnyshinylegs"
	fulllegs = "lopunnyshinylegsbelly"

end