require "/scripts/vore/npcvore.lua"

legs = "lopunnynormallegs"

fulllegs = "lopunnynormallegsbelly"

voreeffect = "harpyvore"

audio = false

duration = 60

playerLines = {	"Who's in a wabbit womb~?",
				"You'll be such a cute little Buneary",
				"I'm gonna be a bunny mommy~!",
				"Hehe. you'll be my next litter~",
				"Enjoying yourself? I know I am!",
				"Don't worry about me. I've fit bigger in there before."
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
	
	if isPlayer and stopWatch > 60 then
		npc.say("Whoops. I guess you spent a bit too much time in there. Welcome to the family sweety.")
	elseif isPlayer then
		npc.say("Stick around longer next time. I love our visits. I'll make you part of -my- egg group <3")
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